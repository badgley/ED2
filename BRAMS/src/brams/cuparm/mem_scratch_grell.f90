!==========================================================================================!
!    Module mem_scratch_grell - This module contains all Grell's scratch variables that do !
! not depend on ensemble dimensions. This module is shared between shallow and deep        !
! convection.                                                                              !
!==========================================================================================!
module mem_scratch_grell

   !SRF- feb-05-2002 : Variables for cumulus transport scheme
   !                   adapted in july-15-2002 for 5.x version
   !
   implicit none

   !------ Scalars, mostly grid definitions -----------------------------------------------!
   integer ::  mkx         & ! Number of cloud points this grid has;
              ,lpw         & ! Lower point in the vertical for this grid;
              ,kgoff       & ! Offset between BRAMS and Grell's grids
              ,kpbl        & ! PBL when running Nakanishi/Niino
              ,ktpse       ! ! maximum height allowed for cloud top
   real    ::  tscal_kf    ! ! Kain-Fritsch (1990) time scale, for ensemble.
   !---------------------------------------------------------------------------------------!



   !------ 1D dependence (mgmzp), grid-related stuff --------------------------------------!
   real, allocatable, dimension(:) :: &
            z                         & ! Height above surface at model levels          [m]
           ,z_cup                     & ! Height above surface at cloud levels          [m]
           ,dzd_cld                   & ! Layer thickness for downdraft calculation     [m]
           ,dzu_cld                   ! ! Layer thickness for updraft calculation       [m]
   !---------------------------------------------------------------------------------------!


   !------ Scalar, static control variable ------------------------------------------------!
   real                            ::    &
            wbuoymin                     ! ! Minimum buoyant velocity               [  m/s]

   !------ Scalars, surface variables -----------------------------------------------------!
   real    ::  co2sur    & ! Surface: CO2 mixing ratio                             [   ppm]
              ,exnersur  & ! Surface: Exner function                               [J/kg/K]
              ,psur      & ! Surface: pressure                                     [    Pa]
              ,qtotsur   & ! Surface: mixing ratio                                 [ kg/kg]
              ,qvapsur   & ! Surface: mixing ratio                                 [ kg/kg]
              ,qliqsur   & ! Surface: mixing ratio                                 [ kg/kg]
              ,qicesur   & ! Surface: mixing ratio                                 [ kg/kg]
              ,tsur      & ! Surface: temperature                                  [     K]
              ,theivsur  & ! Surface: ice-vapour equivalent potential temperature  [     K]
              ,thilsur   ! ! Surface: ice-liquid potential temperature             [     K]
   !---------------------------------------------------------------------------------------!


   !------ Scalars, variables at current time step ----------------------------------------!
   real    ::  mconv     ! ! Column integrated mass flux convergence              [kg/m�/s]
   !---------------------------------------------------------------------------------------!

   !------ 1D dependence (mgmzp), variables with all forcings but convection --------------!
     real, allocatable, dimension(:) ::          &
            dco2dt         & ! Temporary CO2 mixing ratio tendency               [   ppm/s]
           ,dqtotdt        & ! Temporary total mixing ratio tendency             [ kg/kg/s]
           ,dthildt        & ! Temporary temperature tendency                    [     K/s]
           ,dtkedt         & ! Temporary TKE tendency                            [  J/kg/s]
           ,co2            & ! CO2 Mixing ratio                                  [     ppm]
           ,exner          & ! Exner function                                    [  J/kg/K]
           ,omeg           & ! Omega - Lagrangian pressure tendency              [    Pa/s]
           ,p              & ! Pressure                                          [      Pa]
           ,rho            & ! Air density                                       [   kg/m�]
           ,qtot           & ! Total mixing ratio                                [   kg/kg]
           ,qice           & ! Ice mixing ratio                                  [   kg/kg]
           ,qliq           & ! Liquid water mixing ratio                         [   kg/kg]
           ,qvap           & ! Water vapour mixing ratio                         [   kg/kg]
           ,t              & ! Temperature                                       [       K]
           ,thil           & ! Ice-liquid potential temperature                  [       K]
           ,theiv          & ! Ice-vapour equivalent potential temperature       [       K]
           ,tke            & ! Turbulent kinetic energy                          [    J/kg]
           ,sigw           & ! Vertical velocity standard deviation              [     m/s]
           ,uwind          & ! Zonal wind speed                                  [     m/s]
           ,vwind          & ! Meridional wind speed                             [     m/s]
           ,wwind          ! ! Vertical velocity                                 [     m/s]
   !---------------------------------------------------------------------------------------!



   !------ 1D dependence (mgmzp), variables at current time step --------------------------!
   real, allocatable, dimension(:) :: &
            co20      & ! CO2 mixing ratio                                       [     ppm]
           ,exner0    & ! Exner function                                         [  J/kg/K]
           ,p0        & ! Pressure with forcing                                  [     hPa]
           ,qtot0     & ! Total mixing ratio                                     [   kg/kg]
           ,qice0     & ! Ice mixing ratio                                       [   kg/kg]
           ,qliq0     & ! Liquid water mixing ratio                              [   kg/kg]
           ,qvap0     & ! Water vapour mixing ratio                              [   kg/kg]
           ,rho0      & ! Air density                                            [   kg/m�]
           ,t0        & ! Temperature                                            [       K]
           ,thil0     & ! Ice-liquid potential temperature                       [       K]
           ,theiv0    & ! Ice-vapour equivalent potential temperature            [       K]
           ,tke0      ! ! Turbulent Kinetic Energy                               [    J/kg]
   !---------------------------------------------------------------------------------------!



   !------ 1D dependence (mgmzp), forcing due to convectivion -----------------------------!
   real, allocatable, dimension(:) :: &
            outco2    & ! Total CO2 mixing ratio tendency due to cumulus         [   ppm/s]
           ,outqtot   & ! Total water mixing ratio tendency due to cumulus       [ kg/kg/s]
           ,outthil   ! ! Ice-liquid potential temperature tendency due to Cu    [     K/s]  

   !----- Scalar, forcing due to convection -----------------------------------------------!
   real :: precip     ! ! Precipitation rate

   !=======================================================================================!
   !=======================================================================================!


   contains



   !=======================================================================================!
   !=======================================================================================!
   subroutine alloc_scratch_grell(mgmzp)

      implicit none
      integer, intent(in)                    :: mgmzp

      allocate (z             (mgmzp))
      allocate (z_cup         (mgmzp))
      allocate (dzd_cld       (mgmzp))
      allocate (dzu_cld       (mgmzp))

      allocate (dco2dt        (mgmzp))
      allocate (dqtotdt       (mgmzp))
      allocate (dthildt       (mgmzp))
      allocate (dtkedt        (mgmzp))
      allocate (co2           (mgmzp))
      allocate (exner         (mgmzp))
      allocate (omeg          (mgmzp))
      allocate (p             (mgmzp))
      allocate (qtot          (mgmzp))
      allocate (qvap          (mgmzp))
      allocate (qliq          (mgmzp))
      allocate (qice          (mgmzp))
      allocate (rho           (mgmzp))
      allocate (t             (mgmzp))
      allocate (thil          (mgmzp))
      allocate (theiv         (mgmzp))
      allocate (tke           (mgmzp))
      allocate (sigw          (mgmzp))
      allocate (uwind         (mgmzp))
      allocate (vwind         (mgmzp))
      allocate (wwind         (mgmzp))

      allocate (co20          (mgmzp))
      allocate (exner0        (mgmzp))
      allocate (p0            (mgmzp))
      allocate (qtot0         (mgmzp))
      allocate (qvap0         (mgmzp))
      allocate (qliq0         (mgmzp))
      allocate (qice0         (mgmzp))
      allocate (rho0          (mgmzp))
      allocate (t0            (mgmzp))
      allocate (thil0         (mgmzp))
      allocate (theiv0        (mgmzp))
      allocate (tke0          (mgmzp))
     
      allocate (outqtot       (mgmzp))
      allocate (outthil       (mgmzp))
      allocate (outco2        (mgmzp))

      return
   end subroutine alloc_scratch_grell
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   subroutine dealloc_scratch_grell()

      implicit none
     
      if(allocated(z             )) deallocate (z             )
      if(allocated(z_cup         )) deallocate (z_cup         )
      if(allocated(dzd_cld       )) deallocate (dzd_cld       )
      if(allocated(dzu_cld       )) deallocate (dzu_cld       )

      if(allocated(dco2dt        )) deallocate (dco2dt        )
      if(allocated(dqtotdt       )) deallocate (dqtotdt       )
      if(allocated(dthildt       )) deallocate (dthildt       )
      if(allocated(dtkedt        )) deallocate (dtkedt        )
      if(allocated(co2           )) deallocate (co2           )
      if(allocated(exner         )) deallocate (exner         )
      if(allocated(omeg          )) deallocate (omeg          )
      if(allocated(p             )) deallocate (p             )
      if(allocated(qtot          )) deallocate (qtot          )
      if(allocated(qvap          )) deallocate (qvap          )
      if(allocated(qliq          )) deallocate (qliq          )
      if(allocated(qice          )) deallocate (qice          )
      if(allocated(rho           )) deallocate (rho           )
      if(allocated(t             )) deallocate (t             )
      if(allocated(thil          )) deallocate (thil          )
      if(allocated(theiv         )) deallocate (theiv         )
      if(allocated(tke           )) deallocate (tke           )
      if(allocated(sigw          )) deallocate (sigw          )
      if(allocated(uwind         )) deallocate (uwind         )
      if(allocated(vwind         )) deallocate (vwind         )
      if(allocated(wwind         )) deallocate (wwind         )

      if(allocated(co20          )) deallocate (co20          )
      if(allocated(exner0        )) deallocate (exner0        )
      if(allocated(p0            )) deallocate (p0            )
      if(allocated(qtot0         )) deallocate (qtot0         )
      if(allocated(qvap0         )) deallocate (qvap0         )
      if(allocated(qliq0         )) deallocate (qliq0         )
      if(allocated(qice0         )) deallocate (qice0         )
      if(allocated(rho0          )) deallocate (rho0          )
      if(allocated(t0            )) deallocate (t0            )
      if(allocated(thil0         )) deallocate (thil0         )
      if(allocated(theiv0        )) deallocate (theiv0        )
      if(allocated(tke0          )) deallocate (tke0          )

      if(allocated(outco2        )) deallocate (outco2        )
      if(allocated(outqtot       )) deallocate (outqtot       )
      if(allocated(outthil       )) deallocate (outthil       )

      return
   end subroutine dealloc_scratch_grell
   !=======================================================================================!
   !=======================================================================================!






   !=======================================================================================!
   !=======================================================================================!
   subroutine zero_scratch_grell

      implicit none
      
      if (allocated(z             )) z             = 0.
      if (allocated(z_cup         )) z_cup         = 0.
      if (allocated(dzd_cld       )) dzd_cld       = 0.
      if (allocated(dzu_cld       )) dzu_cld       = 0.

      if (allocated(dco2dt        )) dco2dt        = 0.
      if (allocated(dqtotdt       )) dqtotdt       = 0.
      if (allocated(dthildt       )) dthildt       = 0.
      if (allocated(dtkedt        )) dtkedt        = 0.

      if (allocated(co2           )) co2           = 0.
      if (allocated(exner         )) exner         = 0.
      if (allocated(omeg          )) omeg          = 0.
      if (allocated(p             )) p             = 0.
      if (allocated(qtot          )) qtot          = 0.
      if (allocated(qvap          )) qvap          = 0.
      if (allocated(qliq          )) qliq          = 0.
      if (allocated(qice          )) qice          = 0.
      if (allocated(rho           )) rho           = 0.
      if (allocated(t             )) t             = 0.
      if (allocated(thil          )) thil          = 0.
      if (allocated(theiv         )) theiv         = 0.
      if (allocated(tke           )) tke           = 0.
      if (allocated(sigw          )) sigw          = 0.
      if (allocated(uwind         )) uwind         = 0.
      if (allocated(vwind         )) vwind         = 0.
      if (allocated(wwind         )) wwind         = 0.

      if (allocated(co20          )) co20          = 0.
      if (allocated(exner0        )) exner0        = 0.
      if (allocated(p0            )) p0            = 0.
      if (allocated(qtot0         )) qtot0         = 0.
      if (allocated(qvap0         )) qvap0         = 0.
      if (allocated(qliq0         )) qliq0         = 0.
      if (allocated(qice0         )) qice0         = 0.
      if (allocated(rho0          )) rho0          = 0.
      if (allocated(t0            )) t0            = 0.
      if (allocated(thil0         )) thil0         = 0.
      if (allocated(theiv0        )) theiv0        = 0.
      if (allocated(tke0          )) tke0          = 0.

      if(allocated(outqtot        )) outqtot       = 0.
      if(allocated(outthil        )) outthil       = 0.
      if(allocated(outco2         )) outco2        = 0.

      !------------------------------------------------------------------------------------!
      ! Flushing scalars, we don't need to check for allocation here...                    !
      !------------------------------------------------------------------------------------!
      !----- Integer variables ------------------------------------------------------------!
      mkx               = 0
      lpw               = 0
      kgoff             = 0
      kpbl              = 0
      ktpse             = 0

      !----- Real variables. --------------------------------------------------------------!
      mconv             = 0.

      co2sur            = 0.
      exnersur          = 0.
      psur              = 0.
      qtotsur           = 0.
      qvapsur           = 0.
      qliqsur           = 0.
      qicesur           = 0.
      tsur              = 0.
      theivsur          = 0.
      thilsur           = 0.
      precip            = 0.
      !------------------------------------------------------------------------------------!

      return

   end subroutine zero_scratch_grell
   !=======================================================================================!
   !=======================================================================================!
end module mem_scratch_grell
!==========================================================================================!
!==========================================================================================!
