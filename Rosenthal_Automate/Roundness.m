function roundness = Roundness(area, circ)
    roundness = 4.*pi.*area./(circ.^2);
    if isnan(roundness)
        roundness = 0;
    end
end