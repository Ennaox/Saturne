!-------------------------------------------------------------------------------

! This file is part of code_saturne, a general-purpose CFD tool.
!
! Copyright (C) 1998-2022 EDF S.A.
!
! This program is free software; you can redistribute it and/or modify it under
! the terms of the GNU General Public License as published by the Free Software
! Foundation; either version 2 of the License, or (at your option) any later
! version.
!
! This program is distributed in the hope that it will be useful, but WITHOUT
! ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
! FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
! details.
!
! You should have received a copy of the GNU General Public License along with
! this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
! Street, Fifth Floor, Boston, MA 02110-1301, USA.

!-------------------------------------------------------------------------------

!> \file entsor.f90
!> \brief Module for input/output

module entsor

  !=============================================================================
  use, intrinsic :: iso_c_binding
  use paramx

  implicit none

  !=============================================================================

  !> \defgroup entsor Module for input/output

  !> \addtogroup entsor
  !> \{

  !> standard output
  integer, save :: nfecra

  !> name of file, see usvort module.
  character(len=13), save :: ficdat

  !> saving period of the restart files
  !>   - -2: no restart at all
  !>   - -1: only at the end of the calculation
  !>   - 0: by default (four times during the calculation)
  !>   - \>0: period
  integer, save :: ntsuit

  !> field key for output label (\ref label field keyword).
  integer, save :: keylbl = -1

  !> field key for logging (\ref log field keyword).
  integer, save :: keylog = -1

  !> <a name="keyvis"></a>
  !> field key for postprocessing output (\ref post_vis field keyword).
  integer, save :: keyvis = -1

  !> \}

  !> \defgroup userfile Additional user files

  !> \addtogroup userfile
  !> \{

  !> name of the thermochemical data file for combustion.
  !>
  !> Useful in case of gas or pulverized coal combustion.
  character(len=64), save :: ficfpp, ficrad

  !> logical unit of the thermochemical data file.
  !> Useful in case of gas or pulverized coal combustion or electric arcs;
  integer, save :: impfpp, imprad

  !> use Janaf (=1) or not (=0)
  integer, save :: indjon

  !> Input files for the atmospheric specific physics
  !> ficmet is moved to C.
  !> Get it in Fortran with atmo_get_meteo_file_name

  !> \}

  !> \defgroup history History user files

  !> \addtogroup history
  !> \{

  !> directory in which the potential chronological record files generated by
  !> the Kernel will be written (path related to the execution directory)
  !> - useful if and only if chronological record files are generated
  character(len=80), save :: emphis

  !> prefix of history files
  character(len=80), save :: prehis

  !> mobile structure variables output unit
  integer, save :: impsth(2)

  !> time plot format (1: .dat, 2: .csv, 3: both)
  integer, save :: tplfmt

  !> output period of the chronological record files:
  !> - -1: no output
  !> - \>0: period  (every \ref nthist time step)
  !>
  !> The default value is -1 if there is no chronological record file to
  !> generate (if there is no probe, or no active probe output) and 1 otherwise.
  !> If chronological records are generated, it is usually wise to keep the
  !> default value \ref nthist=1, in order to avoid missing any high frequency
  !> evolution (unless the total number of time steps is much too big).
  !> Useful if and only if chronological record files are generated
  integer, save :: nthist

  !> frhist : output frequency in seconds
  double precision, save :: frhist

  !> write indicator (O or 1) for history of internal mobile structures
  integer, save :: ihistr

  !> \}

  !> \addtogroup userfile
  !> \{

  ! --- Fichiers utilisateurs

  !> maximal number of user files
  integer    nusrmx
  parameter(nusrmx=20)

  !> unit numbers for potential user specified files.
  !> Useful if and only if the user needs files
  !> (therefore always useful, by security)
  integer, save ::      impusr(nusrmx)

  !> \}

  !> \defgroup log Output log

  !> \addtogroup log
  !> \{

  !> writing period in the execution report file.
  !>   - -1: no writing
  !>   - \> 0: period (every \ref ntlist time step). The value of
  !> \ref ntlist must be adapted according to the number of iterations
  !> carried out in the calculation. Keeping \ref ntlist to 1 will indeed provide
  !> a maximum volume of information, but if the number of time steps
  !> is too large the execution report file might become too big and unusable
  !> (problems with disk space, memory problems while opening the file with a
  !> text editor, problems finding the desired information in the file, ...).
  integer(c_int), pointer, save :: ntlist

  !> \}

  !=============================================================================

  interface

    !---------------------------------------------------------------------------

    !> \cond DOXYGEN_SHOULD_SKIP_THIS

    !---------------------------------------------------------------------------

    ! Interface to C function retrieving pointers of ntlist

    subroutine cs_f_log_frequency_get_pointer(ntlist)             &
      bind(C, name='cs_f_log_frequency_get_pointer')
      use, intrinsic :: iso_c_binding
      implicit none
      type(c_ptr), intent(out) :: ntlist
    end subroutine cs_f_log_frequency_get_pointer

    !---------------------------------------------------------------------------

    !> (DOXYGEN_SHOULD_SKIP_THIS) \endcond

    !---------------------------------------------------------------------------

  end interface

  !=============================================================================

contains

  !=============================================================================

  !> \brief Flush Fortran log

  subroutine flush_nfecra() bind(C, name='cs_f_flush_logs')
    flush(nfecra)
  end subroutine flush_nfecra

  !=============================================================================

  !> \brief Map ntlist from C to Fortran

  subroutine listing_writing_period_init

    use, intrinsic :: iso_c_binding
    implicit none

    ! Local variables

    type(c_ptr) :: c_ntlist

    call cs_f_log_frequency_get_pointer(c_ntlist)

    call c_f_pointer(c_ntlist, ntlist)

  end subroutine listing_writing_period_init

  !=============================================================================

end module entsor
