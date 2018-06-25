%% CALL THE GAUMANN CALCULATION
function [T_field] = Gaumann_Calculation(T_0,q,v,r_b,A,k,a,x_val,y_val,z_val)

%% INTEGRATION FUNCTION OF TEMPERATURE FIELD
% All equations from Rosenthal 1946

% Rosenthal implementation
Temp = @(x,y,z) A.*q.*exp(-v.*(x+sqrt(x.^2+y.^2+z.^2))./(2.*a))./(2.*pi.*k.*sqrt(x.^2+y.^2+z.^2));

%% CREATE VOLUME AND TEMPERATURE FIELD
% Create 3D mesh, swapped X and Y, so in correct order
[Y,X,Z] = meshgrid(x_val,y_val,z_val);

% Calculate the Temperature field using the function defined above
dT_calc = Temp(Y,X,Z);
T_field = T_0 + dT_calc;

end


