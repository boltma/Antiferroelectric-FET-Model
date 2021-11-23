function Psat = Preisach(Ps, Pr, Ec, Ecshift, Eafe, dirv)
%PREISACH �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    if Eafe > 0
        sgn = 1.0;
    else
        sgn = -1.0;
    end
	wspv = sgn/(2*Ec) * log((Ps+Pr)/(Ps-Pr));
    Pshift = sgn * Ps * tanh(wspv * (- sgn * Ecshift - dirv * Ec));
	Psat = sgn * Ps * tanh(wspv * (Eafe - sgn * Ecshift - dirv * Ec)) - Pshift;
end

