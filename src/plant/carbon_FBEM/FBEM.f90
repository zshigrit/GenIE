program main
      
        implicit none

        real,parameter::Ox=0.21,Ca=410,Rgas=8.314 !Ca in ppm
        real:: Ta=20.0,swc=0.35,I=1500.0,RH=0.6,LAI=5.0 !driving force;I: absorbed PAR
        real:: f_Ci,Ci,Tk,alpha_q
        real:: Vm_25,Ea_vm,Gamma_star25,Ea_gamma,Ea_Kc,Ea_Ko,Kc_25,Ko_25
        real:: r_JmVm
        real:: g1,D0,kn
        real:: Reco0,Q10,a1
        real:: Vm,Gamma_star,Kc,Ko,Jm,Jc,Je,A
        real:: es,D,Gs,An,Ac,Reco,NEE
        character(len=80)::header,header1,header2,header3
        real::head1,head2,head3
        character(len=80),dimension(3)::headers
        namelist /main_para/ f_Ci,alpha_q,Vm_25,Ea_vm,Gamma_star25,Ea_gamma,Ea_Kc, &
                             Ea_Ko,Kc_25,Ko_25,r_JmVm,g1,D0,kn,Reco0,Q10,a1

        open(11,file='FBEM_namelist.nml')
        read(11,nml=main_para)
        close(11)
        
        open(12,file='tair_rh_rad_hourly.in')!,status='old',access ='sequential',form='formatted')
        ! open(13,file='df_swc_daily.in')
        ! open(14,file='df_lai_daily.in')
        read (12,*) header1
        read (12,*) head2
        
        ! read (12,*) Ta,RH,I
        ! headers(1)=header1
        ! headers(2)=header2
        ! headers(3)=header3
        !read (12,'(3f)') header
        !read (13,'(a80)') header
        !read (14,'(a80)') header


        Ci = f_Ci * Ca
        Tk = Ta+273.15
        Vm = Vm_25 * Arrhenius(Ea_vm,Rgas,Tk)
        Gamma_star = Gamma_star25*Arrhenius(Ea_gamma,Rgas,Tk)
        Kc = Kc_25*Arrhenius(Ea_Kc,Rgas,Tk)
        Ko = Ko_25*Arrhenius(Ea_Ko,Rgas,Tk)
        Jm = r_JmVm*Vm

        Jc = Vm*(Ci-Gamma_star)/(Ci+Kc*(1.+Ox/Ko))
        Je = (alpha_q*I*Jm/(sqrt(Jm**2+alpha_q**2*I**2)))*((Ci-Gamma_star)/(4*(Ci+2*Gamma_star)))  
        A = min(Jc,Je)
        
        es = exp(21.382-5347.5/Tk)
        D = 0.1*es*(1-RH)

        Gs = g1*A/((Ca-Gamma_star)*(1+D/D0))
        An = Gs*(Ca-Ci)! top layer canopy photosynthesis
        Ac = An*(1.0-exp(-kn*LAI))/kn

        Reco = Reco0*Q10**(Ta/10)*(swc/(swc+a1)) ! Ta in degree C;a1:moisture coefficient at which respiration is half the maximum
        NEE = Reco-Ac
        
        !print*,'Vm=',Vm, 'A=',A
        !print*,'Gs=',Gs, 'D=',D
        !print*,'Jc=',Jc,'Je=',Je
        print*,'Reco=',Reco,'Ac=',Ac
        !print*,'An=',An,'NEE= ',NEE

        ! print*,'header: ', header1
        ! print*,'header2: ',head2
        ! print*,'header3: ',header3
        ! print*,head1,head2,head3
        ! print*, trim(header1),',', trim(header2),',', trim(header3)
        ! print*, 'headers: ', headers

        ! print*,'headers ', headers 
        ! print*,Ta,RH,I

        close(12)
    contains

!      function Jc(Vmx,Ci,Gamma_star,Kc,Ox,Ko)
!             real:: Vmx,Ci,Gamma_star,Kc,Ox,Ko
!              real:: Jc
!              Jc=Vmx*(Ci-Gamma_star)/(Ci+Kc*(1.+Ox/Ko))
!      end function Jc

      function Arrhenius(Ea,Rgas,Tk)
               real:: Ea,Tk
               real:: Rgas 
               real:: Arrhenius
               Arrhenius=exp((Ea/(Rgas*Tk)*(Tk/298.15-1.)))
      end function Arrhenius


end program main
