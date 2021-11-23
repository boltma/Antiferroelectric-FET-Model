function P = Psub(Ps, Pr, Ec, Ecshift, TU, TD, PU, PD, Eafe, dirv)
%PSUB 此处显示有关此函数的摘要
%   此处显示详细说明

    PU_S = Preisach(Ps,Pr,Ec,Ecshift,TU,dirv);
	PD_S = Preisach(Ps,Pr,Ec,Ecshift,TD,dirv);
	Pafe_S = Preisach(Ps,Pr,Ec,Ecshift,Eafe,dirv);
    
    if Eafe > 0
        mpv = PU / PU_S;
    else
        mpv = PD / PD_S;
    end
        
    P = mpv * Pafe_S;
end

