%module "mylib::mod_std_function"

%include <std_common.i>
%include <std_vector.i>

%template() std::vector<int>;

%exception {
  try {
    $action
  }
  catch (const std::exception &e) {
    rb_raise(rb_eRuntimeError, "%s", e.what());
  }
}

%wrapper %{
#include <functional>
#include <type_traits>
#include <stdexcept>


  template <class R>
    struct FunctorBase {
    R as_impl(VALUE res) {
      return swig::as< R >(res);
    }
  };

  template<> void FunctorBase<void>::as_impl(VALUE ret) {}

  template<class R, class...Args>
    struct Functor : swig::GC_VALUE, FunctorBase<R> {
    typedef std::function<R(Args...)> function_type;

    Functor(VALUE obj = Qnil) : GC_VALUE(obj), is_raised(false) {}

    R operator()(const Args&... args) {
      std::function<VALUE(void)> b_proc = [&]() { return rb_funcall(_obj, rb_intern("call"), sizeof...(Args), swig::from(args)...); };
      VALUE res = rb_rescue2(RUBY_METHOD_FUNC(call_b_proc), (VALUE) &b_proc,
                             RUBY_METHOD_FUNC(r_proc), (VALUE) &is_raised,
                             rb_eStandardError, 0);
      if (is_raised) {
        VALUE backtrace = rb_funcall(res, rb_intern("backtrace"), 0);
        VALUE m = rb_funcall(backtrace, rb_intern("join"), 1, rb_str_new2("\n\t\t"));
        is_raised = false;
        throw std::runtime_error(StringValueCStr(m));
      }
      return FunctorBase<R>::as_impl(res);
    }

    function_type to_function() {
      return *this;
    }

    static VALUE r_proc(VALUE data, VALUE exc) {
      bool *is_raised_ = (bool *) data;
      *is_raised_ = true;
      return exc;
    }

    static VALUE call_b_proc(VALUE b_proc) {
      std::function<VALUE(void)> *f = (std::function<VALUE(void)>*) b_proc;
      return (*f)();
    };

    bool is_raised;
  };

typedef std::function<int(int)> hoge;

 int hunc(std::function<int(int)>& f) {
   return f(9);
 }

%}

template<class R, class Arg1=void, class Arg2=void, class Arg3=void, class Arg4=void, class Arg5=void, class Arg6=void, class Arg7=void, class Arg8=void, class Arg9=void>
struct Functor : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&, const Arg5&, const Arg6&, const Arg7&, const Arg8&, const Arg9&);
  %fragment(SWIG_Traits_frag(R));
  %fragment(SWIG_Traits_frag(Arg1));
  %fragment(SWIG_Traits_frag(Arg2));
  %fragment(SWIG_Traits_frag(Arg3));
  %fragment(SWIG_Traits_frag(Arg4));
  %fragment(SWIG_Traits_frag(Arg5));
  %fragment(SWIG_Traits_frag(Arg6));
  %fragment(SWIG_Traits_frag(Arg7));
  %fragment(SWIG_Traits_frag(Arg8));
  %fragment(SWIG_Traits_frag(Arg9));
};

template<class R, class Arg1, class Arg2, class Arg3, class Arg4, class Arg5, class Arg6, class Arg7, class Arg8>
struct Functor<R, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, void> : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&, const Arg5&, const Arg6&, const Arg7&, const Arg8&);
  %fragment(SWIG_Traits_frag(R));
  %fragment(SWIG_Traits_frag(Arg1));
  %fragment(SWIG_Traits_frag(Arg2));
  %fragment(SWIG_Traits_frag(Arg3));
  %fragment(SWIG_Traits_frag(Arg4));
  %fragment(SWIG_Traits_frag(Arg5));
  %fragment(SWIG_Traits_frag(Arg6));
  %fragment(SWIG_Traits_frag(Arg7));
  %fragment(SWIG_Traits_frag(Arg8));
};

template<class R, class Arg1, class Arg2, class Arg3, class Arg4, class Arg5, class Arg6, class Arg7>
struct Functor<R, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, void, void> : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&, const Arg5&, const Arg6&, const Arg7&);
  %fragment(SWIG_Traits_frag(R));
  %fragment(SWIG_Traits_frag(Arg1));
  %fragment(SWIG_Traits_frag(Arg2));
  %fragment(SWIG_Traits_frag(Arg3));
  %fragment(SWIG_Traits_frag(Arg4));
  %fragment(SWIG_Traits_frag(Arg5));
  %fragment(SWIG_Traits_frag(Arg6));
  %fragment(SWIG_Traits_frag(Arg7));
};

template<class R, class Arg1, class Arg2, class Arg3, class Arg4, class Arg5, class Arg6>
struct Functor<R, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, void, void, void> : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&, const Arg5&, const Arg6&);
  %fragment(SWIG_Traits_frag(R));
  %fragment(SWIG_Traits_frag(Arg1));
  %fragment(SWIG_Traits_frag(Arg2));
  %fragment(SWIG_Traits_frag(Arg3));
  %fragment(SWIG_Traits_frag(Arg4));
  %fragment(SWIG_Traits_frag(Arg5));
  %fragment(SWIG_Traits_frag(Arg6));
};

template<class R, class Arg1, class Arg2, class Arg3, class Arg4, class Arg5>
struct Functor<R, Arg1, Arg2, Arg3, Arg4, Arg5, void, void, void, void> : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&, const Arg5&);
  %fragment(SWIG_Traits_frag(R));
  %fragment(SWIG_Traits_frag(Arg1));
  %fragment(SWIG_Traits_frag(Arg2));
  %fragment(SWIG_Traits_frag(Arg3));
  %fragment(SWIG_Traits_frag(Arg4));
  %fragment(SWIG_Traits_frag(Arg5));
};

template<class R, class Arg1, class Arg2, class Arg3, class Arg4>
struct Functor<R, Arg1, Arg2, Arg3, Arg4, void, void, void, void, void> : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&);
  %fragment(SWIG_Traits_frag(R));
  %fragment(SWIG_Traits_frag(Arg1));
  %fragment(SWIG_Traits_frag(Arg2));
  %fragment(SWIG_Traits_frag(Arg3));
  %fragment(SWIG_Traits_frag(Arg4));
};

template<class R, class Arg1, class Arg2, class Arg3>
struct Functor<R, Arg1, Arg2, Arg3, void, void, void, void, void, void> : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  R operator()(const Arg1&, const Arg2&, const Arg3&);
  %fragment(SWIG_Traits_frag(R));
  %fragment(SWIG_Traits_frag(Arg1));
  %fragment(SWIG_Traits_frag(Arg2));
  %fragment(SWIG_Traits_frag(Arg3));
};

template<class R, class Arg1, class Arg2>
struct Functor<R, Arg1, Arg2, void, void, void, void, void, void, void> : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  R operator()(const Arg1&, const Arg2&);
  %fragment(SWIG_Traits_frag(R));
  %fragment(SWIG_Traits_frag(Arg1));
  %fragment(SWIG_Traits_frag(Arg2));
};

template<class R, class Arg1 >
struct Functor<R, Arg1, void, void, void, void, void, void, void, void> : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  R operator()(const Arg1& a1);
  std::function<R(Arg1)> to_function();
  %fragment(SWIG_Traits_frag(R));
  %fragment(SWIG_Traits_frag(Arg1));
};

template<class R, class Arg1 >
struct Functor<R, void, void, void, void, void, void, void, void, void> : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  R operator()();
  %fragment(SWIG_Traits_frag(R));
};

template<class Arg1, class Arg2>
struct Functor<void, Arg1, Arg2, void, void, void, void, void, void, void> : swig::GC_VALUE {
  Functor(VALUE obj = Qnil) : GC_VALUE(obj) {}
  void operator()(const Arg1&, const Arg2&);
  %fragment(SWIG_Traits_frag(Arg1));
  %fragment(SWIG_Traits_frag(Arg2));
};


template<class R, class Arg>
class std::function {};

%define %std_function(Name, R, ...)
template<>
class std::function<R(__VA_ARGS__)> {
public:
  R operator()(__VA_ARGS__);
};
%template(Name) std::function<R(__VA_ARGS__)>;
%enddef

%template(FunctorIntInt) Functor<int, int>;
%template(FunctorVoidIntDouble) Functor<void, int, double>;
%template(FunctorIntIntDouble) Functor<int, int, double>;
%template(FunctorIntVec) Functor<int, std::vector<int> >;
%template(FunctorIntInt8) Functor<int, int, int, int, int, int, int, int, int>;
%template(FunctorIntInt7) Functor<int, int, int, int, int, int, int, int>;


%std_function(Hoge, int, int);

int hunc(std::function<int(int)>& f);
%init %{
  std::function<int(int)> f = Functor<int, int>();
%}