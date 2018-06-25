function Melt_Properties = Gaumann_Setup(q, v)
    %% MATERIAL PARAMETERS
    T_0 = 298;      % Initial Temp (K)
    r_b = 35e-6;    % Beam radius (m)
    l = 20e-6;         % Layer Thickness (m)
    A = 0.704;        % Absorption coefficient/fudge factor

    T_m = 1609;     % Melting temp (K)   http://www.maher.com/media/pdfs/718-datasheet.pdf
    k = 20.8;       % Thermal Conductivity (Wm^-1K^-1)  from Hunziker2000
    a = 4.9E-6;     % Thermal Diffusivity (m^2s^-1)     from Hunziker2000

    %% SET ANALYSIS LIMITS
    step = 10e-6; % step size

    x_min = -3e-3;
    x_max = 1.5e-3;
    x_val = x_min:step:x_max;

    y_min = -1.5e-3;
    y_max = 1.5e-3;
    y_val = y_min:step:y_max;

    z_min = -0.8e-3;
    z_max = 0;
    z_val = z_min:step:z_max;

    %% RUN TEMPERATURE FIELD CALCULATION AND PLOT FIGURES
    % Calculate the Temperature field using the parameters above
    [T_field] = Gaumann_Calculation(T_0,q,v,r_b,A,k,a,x_val,y_val,z_val);

    % Plot the Temperature field X vs Z and return the maximum depth of the
    % melt track
    % max_melt_depth = Plot_T_field_Y_Z(x_val,y_val,z_val,T_field,l,T_0,T_m)
    Melt_Properties = Plot_T_field_X_Y(x_val,y_val,z_val,T_field,T_0,T_m,r_b,q,v,k);
    Melt_Properties = Plot_T_field_X_Z(x_val,y_val,z_val,T_field,l,T_0,T_m,r_b,q,v, Melt_Properties);

    % Plot time vs Temp for first 5 layers
    Plot_T_t(x_val,y_val,z_val,T_field,l,T_m,q,v)

    % Calculate the meltpool characteristics
    Melt_Properties = Melt_Pool_Shape(x_val,y_val,z_val,T_field,T_m,Melt_Properties);
    Melt_Properties.Power = q;
    Melt_Properties.Velocity = v;
end