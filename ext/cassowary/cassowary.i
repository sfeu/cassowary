%module cassowary
%include typemaps.i
%include "std_string.i"

%{
#include "Cl.h"
#include "ClPoint.h"
%}

%typemap(python,in) vector<double> &{
	if (PyList_Check($source)) {
		int size = PyList_Size($source);
		int i;

		$target = new vector<double>;
		for (i=0; i<size; i++) {
			PyObject *o = PyList_GetItem($source, i);
			if (PyFloat_Check(o)) {
				$target->push_back(PyFloat_AsDouble(o));
			} else if (PyInt_Check(o)) {
				$target->push_back(PyInt_AsLong(o));
			} else {
				PyErr_SetString(PyExc_TypeError,
						"list must contain numbers");
				delete $target;
				return NULL;
			}
		}
	} else {
		PyErr_SetString(PyExc_TypeError, "expected list");
		return NULL;
	}
}

%typemap(python, freearg) vector<double> & {
	delete $source;
}

typedef double Number;
%apply double { Number };

class ClVariable {
public:

  ClVariable(std::string name, Number Value = 0.0); 
      
  std::string Name() const;

  Number Value() const;
  int IntValue() const; 
  void SetValue(Number Value); 
  void ChangeValue(Number Value);

};

class ClPoint {
 public:
  ClPoint();
  //  %name(ClPointXY) ClPoint(Number x, Number y)
  //: clv_x(x), clv_y(y)
  //{ }
  ClPoint(Number x, Number y);

  ClVariable X()
    { return clv_x; }

  ClVariable Y()
    { return clv_y; }

  Number Xvalue() const
    { return X().Value(); }

  Number Yvalue() const
    { return Y().Value(); }

};

class ClStrength {
 public:
  ClStrength(const string &Name, const ClSymbolicWeight &symbolicWeight) ;

};

const ClStrength &ClsRequired();
const ClStrength &ClsStrong();
const ClStrength &ClsMedium();
const ClStrength &ClsWeak();

%except(python) {
	try{
		$function
	} catch (ExCLError &err) {
		PyErr_SetString(PyExc_RuntimeError, err.description().c_str());
		return NULL;
	}
}

class ClConstraint {
 public:
  ClConstraint(const ClStrength &strength = ClsRequired(), double weight = 1.0 );
  virtual ostream &PrintOn(ostream &xo) const = 0;
};

class ClLinearConstraint : public ClConstraint {
 public:

  // Constructor
  ClLinearConstraint(const ClLinearExpression &cle,
		     const ClStrength &strength = ClsRequired(),
		     double weight = 1.0);
};

class ClLinearEquation : public ClLinearConstraint {
 
 public:
 //// Constructors

 // ClLinearEquation(expr,...)    is   expr == 0
 ClLinearEquation(const ClLinearExpression &cle,
		  const ClStrength &strength = ClsRequired(),
		  double weight = 1.0) ;

 // ClLinearEquation(var,expr,...)  is   var == expr
 ClLinearEquation(ClVariable clv,
		  const ClLinearExpression &cle,
		  const ClStrength &strength = ClsRequired(),
		  double weight = 1.0) ;

 // ClLinearEquation(expr,var,...) is   var == expr
 ClLinearEquation(const ClLinearExpression &cle,
		  ClVariable clv,
		  const ClStrength &strength = ClsRequired(),
		  double weight = 1.0);

 // ClLinearEquation(expr,expr,...) is   expr == expr
 ClLinearEquation(const ClLinearExpression &cle1,
		  const ClLinearExpression &cle2,
		  const ClStrength &strength = ClsRequired(),
		  double weight = 1.0);
 virtual ostream &PrintOn(ostream &xo) const;

};

//enum ClInequalityOperator { cnLEQ, cnGEQ };
enum ClCnRelation {cnEQ = 0, cnNEQ = 100, cnLEQ = 2, cnGEQ = -2, cnLT = 3, cnGT = -3 };

class ClLinearInequality : public  ClLinearConstraint{

 public:
 // Constructor
  ClLinearInequality(const ClLinearExpression &cle,
		    const ClStrength &strength = ClsRequired(),
		   double weight = 1.0);
  ClLinearInequality(const ClVariable clv,
		    ClCnRelation op,
		    const ClLinearExpression &cle,
		    const ClStrength &strength = ClsRequired(),
		     double weight = 1.0);
  ClLinearInequality(const ClLinearExpression &cle1,
		    ClCnRelation op,
		    const ClLinearExpression &cle2,
		    const ClStrength &strength = ClsRequired(),
		     double weight = 1.0);
  virtual ostream &PrintOn(ostream &xo) const;
};

class ClLinearExpression  {
 public:

  // Convert from ClVariable to a ClLinearExpression
  // this replaces ClVariable::asLinearExpression
  ClLinearExpression(ClVariable clv, Number Value = 1.0,
	  Number Constant = 0.0);
  //%name(ClLinearExpressionNum) ClLinearExpression(Number num = 0.0);
  ClLinearExpression(Number num = 0.0);

  virtual ~ClLinearExpression();

  // Return a new linear Expression formed by multiplying self by x.
  // (Note that this result must be linear.)
  ClLinearExpression Times(Number x) const;

  // Return a new linear Expression formed by multiplying self by x.
  // (Note that this result must be linear.)
  %name(TimesE) ClLinearExpression Times(const ClLinearExpression &expr)
	const;

  // Return a new linear Expression formed by adding x to self.
  ClLinearExpression Plus(const ClLinearExpression &expr) const;

  // Return a new linear Expression formed by subtracting x from self.
  ClLinearExpression Minus(const ClLinearExpression &expr) const;

  // Return a new linear Expression formed by dividing self by x.
  // (Note that this result must be linear.)
  ClLinearExpression Divide(Number x) const;

  // Return a new linear Expression formed by dividing self by x.
  // (Note that this result must be linear.)
  %name(DivideE) ClLinearExpression Divide(const ClLinearExpression &expr)
	const;

  // Return a new linear Expression (aNumber/this).  Since the result
  // must be linear, this is permissible only if 'this' is a Constant.
  ClLinearExpression DivFrom(const ClLinearExpression &expr) const;

  // Return a new linear Expression (aNumber-this).
  ClLinearExpression SubtractFrom(const ClLinearExpression &expr) const
  { return expr.Minus(*this); }

  // Add n*expr to this Expression for another Expression expr.
  ClLinearExpression &AddExpression(const ClLinearExpression &expr, 
				    Number n = 1.0);

  // Add n*expr to this Expression for another Expression expr.
  // Notify the solver if a variable is added or deleted from this
  // Expression.
  %name(addExpression1) ClLinearExpression
  	&AddExpression(const ClLinearExpression &expr, Number n,
				    ClVariable subject,
				    ClSimplexSolver &solver);

  // Add a term c*v to this Expression.  If the Expression already
  // contains a term involving v, Add c to the existing coefficient.
  // If the new coefficient is approximately 0, delete v.
  ClLinearExpression &AddVariable(ClVariable v, Number c);

  // Add a term c*v to this Expression.  If the Expression already
  // contains a term involving v, Add c to the existing coefficient.
  // If the new coefficient is approximately 0, delete v.  Notify the
  // solver if v appears or disappears from this Expression.
  %name(addVariable1) ClLinearExpression &AddVariable(ClVariable v,
				  Number c,
				  ClVariable subject,
				  ClSimplexSolver &solver);

  // Add a term c*v to this Expression.  If the Expression already
  // contains a term involving v, Add c to the existing coefficient.
  // If the new coefficient is approximately 0, delete v.
  ClLinearExpression &setVariable(ClVariable v, Number c)
    {assert(c != 0.0);  my_terms[&v] = c; return *this; }

  // Return a variable in this Expression.  (It is an error if this
  // Expression is Constant -- signal ExCLInternalError in that case).
  ClVariable AnyPivotableVariable() const;
};

class ClSimplexSolver {

 public:

  // Constructor
  ClSimplexSolver();
  ~ClSimplexSolver();
  
  // Add constraints so that lower<=var<=upper.  (nil means no  bound.)
  ClSimplexSolver &AddLowerBound(ClVariable v, Number lower);

  ClSimplexSolver &AddUpperBound(ClVariable v, Number upper);

  ClSimplexSolver &AddBounds(ClVariable v, Number lower,
  	Number upper);

  // Add the constraint cn to the tableau
  ClSimplexSolver &AddConstraint(ClConstraint *const pcn) ;

  // Add weak stays to the x and y parts of each point. These have
  // increasing weights so that the solver will try to satisfy the x
  // and y stays on the same point, rather than the x stay on one and
  // the y stay on another.
  // !!! Find some way to turn a Python list into a vector !!!
  ClSimplexSolver &AddPointStays(const vector<const ClPoint *> &listOfPoints);

  ClSimplexSolver &AddPointStay(const ClPoint &clp, const ClStrength &strengt, Number weight);

  %name(addPointStayXY) ClSimplexSolver &AddPointStay(ClVariable vx,
						      ClVariable vy, const ClStrength &strength,Number weight);

  // Add a stay of the given strength (default to weak) of v to the tableau
  ClSimplexSolver &AddStay(ClVariable v,
			   const ClStrength &strength, Number weight =
			   1.0 );

  // Remove the constraint cn from the tableau
  // Also remove any error variable associated with cn
  ClSimplexSolver &RemoveConstraint(ClConstraint *const pcn);

  // Re-initialize this solver from the original constraints, thus
  // getting rid of any accumulated numerical problems.  (Actually,
  // Alan hasn't observed any such problems yet, but here's the method
  // anyway.)
  void Reset();

  // Re-solve the current collection of constraints for new values for
  // the constants of the edit variables.
//  void Resolve(vector<double> &newEditConstants);
  void Resolve(vector<double> &INPUT);

  %name(resolveXY) void Resolve(Number x, Number y);

};

class ClEditConstraint : public ClConstraint {
 public:
  
  ClEditConstraint(ClVariable var,
		   const ClStrength &strength, Number weight = 1.0 );
};

