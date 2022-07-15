"""
radiative transfer: three theories
1. multilayer radiative transfer with scattering using the numerical methods of Norman (1979)
2. the analytical solutions of Goudriaan (1977)
3. two stream approximation (sunlit and shaded leaves)

when solar radication strikes a leaf, a fraction is absorbed and the remainder is scattered
in all directions from both sides of the leaf. Radiation scattered backwards is called
reflected radication and those forward is transmitted radication through the leaf.
(? so transmitted radication belongs to scattered radiation then?)

αl = 1 - ρl - τl = 1 - ωl 
where ωl is the leaf scattering coefficient.

Solar radiation is divided into two braod spectral bands: visible and near-infrared.
Green leaves typically absorb more than 80% visable waveband that stricks the leaf.
The light is used during photosythesis. less than 50% of NIR waveband. 

!!! LIGHT TRANSMISSION WITHOUT SCATTERING !!!
Consider a medium of cross-sectional area A and thickness dz oriented perpendicular to 
the direction of light penetration. The medium contains random, NONOVERLAPPING opaque
(i.e., black) particles. A photon of light is absorbed if it strikes the particle and
is otherwise transmitted through the medium. 
(my understanding would be the medium is a canopy layer with gaps for unscattering)

For black leaf, I = I0*exp(-L) where L is leaf area index. This equation applies to horizontal 
leaf surfaces and for sunlight received from directly overhead.
For leaves of any orientation or for sunlight at directions other than vertical, leaf area L must be
adjusted for the projected leaf area onto a horizontal plane LH. THIS IS ACHIEVED BY INTRODUCING
THE EXTINCTION COEFFICIENT FOR DIRECT BEAM Kb, which is defined as LH/L.  

A general expression that describes transmission of direct beam radiation through a homogenous canopy 
of randomly placed leaves in the ABSENCE OF SCATTERING is dI/dL = -Kb*I and I = Isky,b * exp(-Kb*L).
The value Kb varies with leaf orientation and solar angle.

The direct beam transmittance Tau_b = exp(-Kb*X) describes the ratio of MEAN irradiance on a horizontal 
surface at a depth in the canopy with cumulative leaf area index X. This also describes **fsun**, the 
fractional area on a horizontal plane at x that is illuminated by beam radiation, more commonly 
referred to as the sulit fraction. f_sun(X) =  exp(-Kb*X)! 1-f_sun is shaded. Cumulative Lsun = 
integral(f_sun(x)dx) = (1-exp(-KbL))/Kb.  

"""