%% CALL THE GAUMANN CALCULATION
function [T_field] = Gaumann_Calculation(T_0,q,v,r_b,A,k,a,x_val,y_val,z_val)

%% INTEGRATION FUNCTION OF TEMPERATURE FIELD
% All equations from Appendix A of "Single-crystal laser deposition of superalloys: Processing-microstructure maps"

% Define the equation within the integral
int_final = @(x,y,z,t) (exp(-2.*(((x+v.*t).^2+y.^2)./((2.*r_b).^2+8.*a.*t))-z.^2./(4.*a.*t)))./(sqrt(a.*t).*((2.*r_b).^2+8.*a.*t));

% Integrate wrt t (between 0 and infinity)
int_out = @(x,y,z) integral(@(t) int_final(x,y,z,t),0,inf,'ArrayValued',true);

% Calculate the final Temperature (eqn A2, A3)
dT = @(x,y,z) 2.*a.*A.*q.*int_out(x,y,z)./(k.*pi.^1.5);
% dTdx = @(x,y,z) diff(T,x);
% dTdt = @(x,y,z,t) 2.*a.*A.*q.*int_final(x,y,z,t)./(k.*pi.^1.5);

%% CREATE VOLUME AND TEMPERATURE FIELD
% Create 3D mesh, swapped X and Y, so in correct order
[Y,X,Z] = meshgrid(x_val,y_val,z_val);

% Calculate the Temperature field using the function defined above
dT_calc = dT(Y,X,Z);
T_field = T_0 + dT_calc;

% Gx_func = @(x,y,z,t)  -4.*dT_calc.*(x+v.*t)/((2.*r_b)^2+8.*a.*t);
% Gx = Gx_func(Y,X,Z,1e-6);
% CR = dTdt(Y,X,Z,1e-10);
% CR_x = squeeze(CR(find(y_val==0),:,length(z_val)));

end


