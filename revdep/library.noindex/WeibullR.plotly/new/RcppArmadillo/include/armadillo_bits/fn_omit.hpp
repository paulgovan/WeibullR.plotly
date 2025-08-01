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


//! \addtogroup fn_omit
//! @{



template<typename T1>
arma_warn_unused
inline
typename enable_if2< is_arma_type<T1>::value, const Op<T1, op_omit> >::result
omit_nan(const T1& X)
  {
  arma_debug_sigprint();
  
  return Op<T1, op_omit>(X, 1, 0);
  }



template<typename T1>
arma_warn_unused
inline
typename enable_if2< is_arma_type<T1>::value, const Op<T1, op_omit> >::result
omit_nonfinite(const T1& X)
  {
  arma_debug_sigprint();
  
  return Op<T1, op_omit>(X, 2, 0);
  }



template<typename T1>
arma_warn_unused
inline
CubeToMatOp<T1, op_omit_cube>
omit_nan(const BaseCube<typename T1::elem_type, T1>& X)
  {
  arma_debug_sigprint();
  
  return CubeToMatOp<T1, op_omit_cube>(X.get_ref(), 1);
  }



template<typename T1>
arma_warn_unused
inline
CubeToMatOp<T1, op_omit_cube>
omit_nonfinite(const BaseCube<typename T1::elem_type, T1>& X)
  {
  arma_debug_sigprint();
  
  return CubeToMatOp<T1, op_omit_cube>(X.get_ref(), 2);
  }



template<typename T1>
arma_warn_unused
inline
typename
enable_if2< is_arma_sparse_type<T1>::value, const SpOp<T1, spop_omit> >::result
omit_nan(const T1& X)
  {
  arma_debug_sigprint();
  
  return SpOp<T1, spop_omit>(X, 1, 0);
  }



template<typename T1>
arma_warn_unused
inline
typename
enable_if2< is_arma_sparse_type<T1>::value, const SpOp<T1, spop_omit> >::result
omit_nonfinite(const T1& X)
  {
  arma_debug_sigprint();
  
  return SpOp<T1, spop_omit>(X, 2, 0);
  }



//! @}
