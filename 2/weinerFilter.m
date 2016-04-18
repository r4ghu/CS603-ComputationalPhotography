function image = weinerFilter(noisy, PSF, E_nsr),

% compute fft of point spread function and obtain the optical transfer function 
OTF = psf2otf(PSF,size(noisy));

%In our problem, we assume that noise to signal power ratio (E_nsr) is given
% The Weiner Filter equation
% G(k,l) = (OTF*(k,l)) / abs(OTF(k,l))^2 + E_nsr(k,l)
% where OTF* is the complex conjugate of OTF

num = conj(OTF);
den = abs(OTF).^2 + E_nsr;

% Since denominator should not be zero, we will replace all den==0 values
% to non zero values slightly greater than zero (eps)
den = max(den,sqrt(eps));

G = num./den;
clear num den OTF E_nsr

% Now we got the filter G in frequency domain. We have to apply this filter
% over frequency domain of I and get the inverse fft of the resulting
% output
image = double(real(ifftn(G .* fftn(noisy))));



end