%% CHARACTERISE MELT POOL SHAPE

function Melt_Properties = Melt_Pool_Shape(x_val,y_val,z_val,T_field,T_m,Melt_Properties)
    %% General Properties
    
    % Calculate total volume
    volume_coordinates = [];
    if Melt_Properties.max_temp > T_m && abs(Melt_Properties.max_depth) > abs(z_val(length(z_val)-1));
        diff_z = z_val+Melt_Properties.max_depth;
        M = min(diff_z(diff_z>0))-Melt_Properties.max_depth;
        I = find(z_val == M);
        for zz = I:length(z_val)
            T_field_plot = squeeze(T_field(:,:,zz));
            cont_XY = contour3(x_val,y_val,T_field_plot,[T_m, T_m]);
            cont_XY = cont_XY(:,2:end);
            cont_XY = [cont_XY;ones(1,size(cont_XY,2))*z_val(zz)];
            volume_coordinates = [volume_coordinates cont_XY];
            close(gcf)
        end
        [Melt_Properties.volume, Melt_Properties.surface_area] = volume_area_3D(volume_coordinates.');
        % trisurf(convhull(volume_coordinates.'), volume_coordinates(1,:),volume_coordinates(2,:),volume_coordinates(3,:));
        
        % Transform to 2x vol to be nearer sphere and area to be 2 stacked
        % meltpools
        total_area = 2.*(Melt_Properties.surface_area-Melt_Properties.XY_Area);
        Melt_Properties.sphericity = Sphericity(2.*Melt_Properties.volume, total_area);
    else
        Melt_Properties.volume = 0;
        Melt_Properties.surface_area = 0;
        Melt_Properties.sphericity = 0;
    end
    
end