// SPDX-License-Identifier: Apache-2.0
// 
// Copyright 2008-2016 Conrad Sanderson (http://conradsanderson.id.au)
// Copyright 2008-2016 National ICT Australia (NICTA)
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ------------------------------------------------------------------------


//! \addtogroup spop_misc
//! @{



namespace priv
  {
  template<typename eT>
  struct functor_scalar_times
    {
    const eT k;
    
    functor_scalar_times(const eT in_k) : k(in_k) {}
    
    arma_inline eT operator()(const eT val) const { return val * k; }
    };
  }



template<typename T1>
inline
void
spop_scalar_times::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_scalar_times>& in)
  {
  arma_debug_sigprint();
  
  typedef typename T1::elem_type eT;
  
  out.init_xform(in.m, priv::functor_scalar_times<eT>(in.aux));
  }



namespace priv
  {
  template<typename T>
  struct functor_cx_scalar_times
    {
    typedef std::complex<T> out_eT;
    
    const out_eT k;
    
    functor_cx_scalar_times(const out_eT in_k) : k(in_k) {}
    
    arma_inline out_eT operator()(const T val) const { return val * k; }
    };
  }



template<typename T1>
inline
void
spop_cx_scalar_times::apply(SpMat< std::complex<typename T1::pod_type> >& out, const mtSpOp< std::complex<typename T1::pod_type>, T1, spop_cx_scalar_times >& in)
  {
  arma_debug_sigprint();
  
  typedef typename T1::pod_type T;
  
  out.init_xform_mt(in.m, priv::functor_cx_scalar_times<T>(in.aux_out_eT));
  }



namespace priv
  {
  struct functor_square
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return val*val; }
    };
  }



template<typename T1>
inline
void
spop_square::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_square>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_square());
  }



namespace priv
  {
  struct functor_sqrt
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return eop_aux::sqrt(val); }
    };
  }



template<typename T1>
inline
void
spop_sqrt::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_sqrt>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_sqrt());
  }



namespace priv
  {
  struct functor_cbrt
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return eop_aux::cbrt(val); }
    };
  }



template<typename T1>
inline
void
spop_cbrt::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_cbrt>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_cbrt());
  }



namespace priv
  {
  struct functor_abs
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return eop_aux::arma_abs(val); }
    };
  }



template<typename T1>
inline
void
spop_abs::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_abs>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_abs());
  }



namespace priv
  {
  struct functor_cx_abs
    {
    template<typename T>
    arma_inline T operator()(const std::complex<T>& val) const { return std::abs(val); }
    };
  }



template<typename T1>
inline
void
spop_cx_abs::apply(SpMat<typename T1::pod_type>& out, const mtSpOp<typename T1::pod_type, T1, spop_cx_abs>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform_mt(in.m, priv::functor_cx_abs());
  }



namespace priv
  {
  struct functor_arg
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return arma_arg<eT>::eval(val); }
    };
  }



template<typename T1>
inline
void
spop_arg::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_arg>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_arg());
  }



namespace priv
  {
  struct functor_cx_arg
    {
    template<typename T>
    arma_inline T operator()(const std::complex<T>& val) const { return std::arg(val); }
    };
  }



template<typename T1>
inline
void
spop_cx_arg::apply(SpMat<typename T1::pod_type>& out, const mtSpOp<typename T1::pod_type, T1, spop_cx_arg>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform_mt(in.m, priv::functor_cx_arg());
  }



namespace priv
  {
  struct functor_real
    {
    template<typename T>
    arma_inline T operator()(const std::complex<T>& val) const { return val.real(); }
    };
  }



template<typename T1>
inline
void
spop_real::apply(SpMat<typename T1::pod_type>& out, const mtSpOp<typename T1::pod_type, T1, spop_real>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform_mt(in.m, priv::functor_real());
  }



namespace priv
  {
  struct functor_imag
    {
    template<typename eT>
    arma_inline eT operator()(const eT                  ) const { return eT(0);      }
    
    template<typename T>
    arma_inline  T operator()(const std::complex<T>& val) const { return val.imag(); }
    };
  }



template<typename T1>
inline
void
spop_imag::apply(SpMat<typename T1::pod_type>& out, const mtSpOp<typename T1::pod_type, T1, spop_imag>& in)
  {
  arma_debug_sigprint();
  
  if(is_cx<typename T1::elem_type>::no)
    {
    const SpProxy<T1> P(in.m);
    
    out.zeros(P.get_n_rows(), P.get_n_cols());
    }
  else
    {
    out.init_xform_mt(in.m, priv::functor_imag());
    }
  }



namespace priv
  {
  struct functor_conj
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return eop_aux::conj(val); }
    };
  }



template<typename T1>
inline
void
spop_conj::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_conj>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_conj());
  }



template<typename T1>
inline
void
spop_repelem::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1, spop_repelem>& in)
  {
  arma_debug_sigprint();
  
  typedef typename T1::elem_type eT;
  
  const unwrap_spmat<T1> U(in.m);
  const SpMat<eT>& X =   U.M;
  
  const uword copies_per_row = in.aux_uword_a;
  const uword copies_per_col = in.aux_uword_b;
  
  const uword out_n_rows = X.n_rows * copies_per_row;
  const uword out_n_cols = X.n_cols * copies_per_col;
  const uword out_nnz    = X.n_nonzero * copies_per_row * copies_per_col;
  
  if( (out_n_rows > 0) && (out_n_cols > 0) && (out_nnz > 0) )
    {
    Mat<uword> locs(2, out_nnz, arma_nozeros_indicator());
    Col<eT>    vals(   out_nnz, arma_nozeros_indicator());
    
    uword* locs_mem = locs.memptr();
    eT*    vals_mem = vals.memptr();
    
    typename SpMat<eT>::const_iterator X_it  = X.begin();
    typename SpMat<eT>::const_iterator X_end = X.end();
    
    for(; X_it != X_end; ++X_it)
      {
      const uword col_base = copies_per_col * X_it.col();
      const uword row_base = copies_per_row * X_it.row();
      
      const eT X_val = (*X_it);
      
      for(uword cols = 0; cols < copies_per_col; cols++)
      for(uword rows = 0; rows < copies_per_row; rows++)
        {
        (*locs_mem) = row_base + rows;  ++locs_mem;
        (*locs_mem) = col_base + cols;  ++locs_mem;
        
        (*vals_mem) = X_val;  ++vals_mem;
        }
      }
    
    out = SpMat<eT>(locs, vals, out_n_rows, out_n_cols);
    }
  else
    {
    out.zeros(out_n_rows, out_n_cols);
    }
  }



template<typename T1>
inline
void
spop_reshape::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1, spop_reshape>& in)
  {
  arma_debug_sigprint();
  
  out = in.m;
  
  out.reshape(in.aux_uword_a, in.aux_uword_b);
  }



template<typename T1>
inline
void
spop_resize::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1, spop_resize>& in)
  {
  arma_debug_sigprint();
  
  out = in.m;
  
  out.resize(in.aux_uword_a, in.aux_uword_b);
  }



namespace priv
  {
  struct functor_floor
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return eop_aux::floor(val); }
    };
  }



template<typename T1>
inline
void
spop_floor::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_floor>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_floor());
  }



namespace priv
  {
  struct functor_ceil
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return eop_aux::ceil(val); }
    };
  }



template<typename T1>
inline
void
spop_ceil::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_ceil>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_ceil());
  }



namespace priv
  {
  struct functor_round
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return eop_aux::round(val); }
    };
  }



template<typename T1>
inline
void
spop_round::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_round>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_round());
  }



namespace priv
  {
  struct functor_trunc
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return eop_aux::trunc(val); }
    };
  }



template<typename T1>
inline
void
spop_trunc::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_trunc>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_trunc());
  }



namespace priv
  {
  struct functor_sign
    {
    template<typename eT>
    arma_inline eT operator()(const eT val) const { return arma_sign(val); }
    };
  }



template<typename T1>
inline
void
spop_sign::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_sign>& in)
  {
  arma_debug_sigprint();
  
  out.init_xform(in.m, priv::functor_sign());
  }



template<typename T1>
inline
void
spop_flipud::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_flipud>& in)
  {
  arma_debug_sigprint();
  
  out = reverse(in.m, 0);
  }



template<typename T1>
inline
void
spop_fliplr::apply(SpMat<typename T1::elem_type>& out, const SpOp<T1,spop_fliplr>& in)
  {
  arma_debug_sigprint();
  
  out = reverse(in.m, 1);
  }



template<typename eT, typename T1>
inline
void
spop_replace::apply(SpMat<eT>& out, const mtSpOp<eT, T1, spop_replace>& in)
  {
  arma_debug_sigprint();
  
  const eT old_val = in.aux;
  const eT new_val = in.aux_out_eT;
  
  out = in.m;
  
  out.replace(old_val, new_val);
  }



//! @}
