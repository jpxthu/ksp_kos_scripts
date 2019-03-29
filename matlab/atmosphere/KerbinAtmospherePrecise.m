function [pPa, pAtm, dens, TK] = KerbinAtmospherePrecise(h_meter)

% https://wiki.kerbalspaceprogram.com/wiki/Kerbin#Atmosphere

h = 7963.75 * h_meter / 1000 / (6371 + 1.25 * h_meter / 1000);

if h <= 11
    pPa = 101325.0 .* (288.15 ./ (288.15 - 6.5 .* h)) .^ (34.1632 / -6.5);
    TK = 288.15 - 6.5 * h;
elseif h <= 20
    pPa = 22632.06 .* exp(-34.1632 .* (h - 11) ./ 216.65);
    TK = 216.65;
elseif h <= 32
    pPa = 5474.889 .* (216.65 ./ (216.65 + h - 20)) .^ 34.1632;
    TK = 196.65 + h;
elseif h <= 47
    pPa = 868.0187 .* (228.65 ./ (228.65 + 2.8 .* (h - 32))) .^ (34.1632 / 2.8);
    TK = 139.05 + 2.8 * h;
elseif h <= 51
    pPa = 110.9063 .* exp(-34.1632 .* (h - 47) ./ 270.65);
    TK = 270.65;
elseif h <= 71
    pPa = 66.93887 .* (270.65 ./ (270.65 - 2.8 .* (h - 51))) .^ (34.1632 / -2.8);
    TK = 413.45 - 2.8 * h;
else
    pPa = 3.956420 .* (214.65 ./ (214.65 - 2 .* (h - 71))) .^ (34.1632 / -2);
    TK = 356.65 - 2.0 * h;
end

pAtm = pPa / 101325.0;
dens = pPa / TK / 287.053;

end
