function sphericity = Sphericity(vol, area)
    sphericity = (pi.^(1/3).*(6.*vol).^(2/3))./area;
end