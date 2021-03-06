--
--  File Name:         AxiStreamOptionsPkg.vhd
--  Design Unit Name:  AxiStreamOptionsPkg
--  Revision:          OSVVM MODELS STANDARD VERSION
--
--  Maintainer:        Jim Lewis      email:  jim@synthworks.com
--  Contributor(s):
--     Jim Lewis      jim@synthworks.com
--
--
--  Description:
--      Defines an abstraction layer to define options settings 
--      for AxiStream.  
--
--
--  Developed by:
--        SynthWorks Design Inc.
--        VHDL Training Classes
--        http://www.SynthWorks.com
--
--  Revision History:
--    Date      Version    Description
--    05/2018   2018.05    Initial revision
--    01/2020   2020.01    Updated license notice
--
--
--  This file is part of OSVVM.
--  
--  Copyright (c) 2018 - 2020 by SynthWorks Design Inc.  
--  
--  Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
--  
--      https://www.apache.org/licenses/LICENSE-2.0
--  
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.
--  
library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;
  use ieee.numeric_std_unsigned.all ;
  use ieee.math_real.all ;

library osvvm ;
    context osvvm.OsvvmContext ;
    
library OSVVM_Common ;
    context OSVVM_Common.OsvvmCommonContext ; 
    
package AxiStreamOptionsPkg is

  -- ========================================================
  --  AxiStreamOptionsType 
  --  Define what model configuration options AxiStream supports
  -- ========================================================

  type AxiStreamOptionsType is (    -- OptVal
    TRANSMIT_READY_TIME_OUT,        -- Integer
    RECEIVE_READY_BEFORE_VALID,     -- Integer
    RECEIVE_READY_DELAY_CYCLES,     -- Integer
    DROP_UNDRIVEN,                  -- boolean
    DEFAULT_ID,                     -- std_logic_vector
    DEFAULT_DEST,                   -- std_logic_vector
    DEFAULT_USER,                   -- std_logic_vector
    DEFAULT_LAST,                   -- integer
    THE_END                         
  ) ;
  

  -- ========================================================
  --  SetAxiStreamOptions / GetAxiStreamOptions
  --  Abstraction layer to SetAxiStreamOptions / GetAxiStreamOptions
  --  from StreamTransactionPkg.  
  --  Allows calls to have enumerated values rather than constants.
  --  This way we do not need to manage constant values.
  --  Places std_logic_vector options in ParamToModel since 
  --  they can be larger than DataToModel
  -- ========================================================

  ------------------------------------------------------------
  procedure SetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    constant OptVal      : In    integer
  ) ;

  ------------------------------------------------------------
  procedure SetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    constant OptVal      : In    boolean
  ) ;

  ------------------------------------------------------------
  procedure SetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    constant OptVal      : In    std_logic_vector
  ) ;

  ------------------------------------------------------------
  procedure GetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    variable OptVal      : Out   integer
  ) ;

  ------------------------------------------------------------
  procedure GetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    variable OptVal      : Out   std_logic_vector
  ) ;


end package AxiStreamOptionsPkg ;

-- /////////////////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////////////////

package body AxiStreamOptionsPkg is

  -- ========================================================
  --  SetAxiStreamOptions / GetAxiStreamOptions
  --  For integer uses normal connections
  --  For std_logic_vector, uses ParamToModel/ParamFromModel 
  -- ========================================================

  ------------------------------------------------------------
  procedure SetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    constant OptVal      : In    integer
  ) is
  begin
    SetModelOptions(TransRec, AxiStreamOptionsType'POS(Option), OptVal) ;
  end procedure SetAxiStreamOptions ;

  ------------------------------------------------------------
  procedure SetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    constant OptVal      : In    std_logic_vector
  ) is
  begin
    TransRec.ParamToModel <= ToTransaction(OptVal, TransRec.ParamToModel'length) ;
    SetModelOptions(TransRec, AxiStreamOptionsType'POS(Option)) ;
  end procedure SetAxiStreamOptions ;

  ------------------------------------------------------------
  procedure SetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    constant OptVal      : In    boolean
  ) is
  begin
    TransRec.BoolToModel <= OptVal ;
    SetModelOptions(TransRec, AxiStreamOptionsType'POS(Option)) ;
  end procedure SetAxiStreamOptions ;

  ------------------------------------------------------------
  procedure GetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    variable OptVal      : Out   integer
  ) is
  begin
    GetModelOptions(TransRec, AxiStreamOptionsType'POS(Option), OptVal) ;
  end procedure GetAxiStreamOptions ;

  ------------------------------------------------------------
  procedure GetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    variable OptVal      : Out   std_logic_vector
  ) is
  begin
    GetModelOptions(TransRec, AxiStreamOptionsType'POS(Option)) ;
    OptVal := FromTransaction(TransRec.ParamFromModel, OptVal'length) ;
  end procedure GetAxiStreamOptions ;

  ------------------------------------------------------------
  procedure GetAxiStreamOptions (
  ------------------------------------------------------------
    signal   TransRec    : InOut StreamRecType ;
    constant Option      : In    AxiStreamOptionsType ;
    variable OptVal      : Out   boolean
  ) is
  begin
    GetModelOptions(TransRec, AxiStreamOptionsType'POS(Option)) ;
    OptVal := TransRec.BoolFromModel ;
  end procedure GetAxiStreamOptions ;

end package body AxiStreamOptionsPkg ;