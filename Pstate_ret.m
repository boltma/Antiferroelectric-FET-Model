function [Psat, TUV, TDV, PUP, PDP, TU_Size, TD_Size, TU_Size_eff, TD_Size_eff, flagu, flagd] = Pstate_ret(Ps, Pr, Ec, Ecshift, tfe, v_pre, v, dirv_pre, dirv, Pstate_pre, Es, TUV, TDV, PUP, PDP, TU_Size, TD_Size, TU_Size_eff, TD_Size_eff, flagu, flagd)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   
    Eafe = v / tfe;
    
    try
        if dirv == 1
            if dirv_pre == dirv
                if Eafe < TUV(TU_Size) && flagu == 1
                    TUV(TU_Size + 1) = Eafe;
                    PUP(TU_Size + 1) = Pstate_pre;
                    TU_Size = TU_Size + 1;
                    TU_Size_eff = TU_Size - 1;
                    TD_Size_eff = TD_Size;
                    flagu = -1;
                elseif TU_Size > 1 && Eafe < TUV(TU_Size - 1)
                    TUV(TU_Size) = Eafe;
                    PUP(TU_Size) = Pstate_pre;
                    TU_Size_eff = TU_Size - 1;
                    TD_Size_eff = TD_Size;
                else
                    TUV(TU_Size) = 0;
                    TUV(TU_Size - 1) = 0;
                    PUP(TU_Size) = 0;
                    PUP(TU_Size - 1) = 0;
                    TU_Size = TU_Size - 2;
                    TDV(TD_Size) = 0;
                    PDP(TD_Size) = 0;
                    TD_Size = TD_Size - 1;

                    TUV(TU_Size + 1) = Eafe;
                    PUP(TU_Size + 1) = Pstate_pre;
                    TU_Size = TU_Size + 1;
                    TU_Size_eff = TU_Size - 1;
                    TD_Size_eff = TD_Size;
                end
                flagd = 1;
            end
        elseif dirv == -1
            if dirv_pre == dirv
                if Eafe > TDV(TD_Size) && flagd == 1
                    TDV(TD_Size + 1) = Eafe;
                    PDP(TD_Size + 1) = Pstate_pre;
                    TD_Size = TD_Size + 1;
                    TD_Size_eff = TD_Size - 1;
                    TU_Size_eff = TU_Size;	
                    flagd = -1;
                elseif TD_Size > 1 && Eafe > TDV(TD_Size - 1)
                    TDV(TD_Size) = Eafe;
                    PDP(TD_Size) = Pstate_pre;
                    TD_Size_eff = TD_Size - 1;
                    TU_Size_eff = TU_Size;	
                else
                    TDV(TD_Size) = 0;
                    TDV(TD_Size - 1) = 0;
                    PDP(TD_Size) = 0;
                    PDP(TD_Size - 1) = 0;
                    TD_Size = TD_Size - 2;
                    TUV(TU_Size) = 0;
                    PUP(TU_Size) = 0;
                    TU_Size = TU_Size-1;

                    TDV(TD_Size + 1) = Eafe;
                    PDP(TD_Size + 1) = Pstate_pre;
                    TD_Size = TD_Size + 1;
                    TD_Size_eff = TD_Size - 1;
                    TU_Size_eff = TU_Size;
                end
                flagu = 1;
            end
        end
    catch
        warning("Not converging");
        Es = 20e6;
        TUV = [Es];
        TDV = [-Es];
        PUP = [Ps];
        PDP = [-Ps];
        TU_Size = 1;
        TD_Size = 1;
        TU_Size_eff = TU_Size;
        TD_Size_eff = TD_Size;
        flagu = 1;
        flagd = 1;
    end
    
    if sign(v) == 1 && sign(v_pre) == -1
        TUV = [Es];
        TDV = [-Es];
        PUP = [Ps];
        PDP = [-Ps];
        TU_Size = 1;
        TD_Size = 1;
        TU_Size_eff = TU_Size;
        TD_Size_eff = TD_Size;
        flagu = 1;
        flagd = -1;
    elseif sign(v) == -1 && sign(v_pre) == 1
        TUV = [Es];
        TDV = [-Es];
        PUP = [Ps];
        PDP = [-Ps];
        TU_Size = 1;
        TD_Size = 1;
        TU_Size_eff = TU_Size;
        TD_Size_eff = TD_Size;
        flagu = -1;
        flagd = 1;
    end
    
    if dirv == 1
        Psat = Psub(Ps, Pr, Ec, Ecshift, TUV(TU_Size_eff), TDV(TD_Size), PUP(TU_Size_eff), PDP(TD_Size), Eafe, dirv);
    else
        Psat = Psub(Ps, Pr, Ec, Ecshift, TUV(TU_Size), TDV(TD_Size_eff), PUP(TU_Size), PDP(TD_Size_eff), Eafe, dirv);
    end
%     
%     if abs(Psat - Pstate_pre) > 1e-7
%         dirv = -dirv;
%         if dirv == 1
%             Psat = Psub(Ps, Pr, Ec, Ecshift, TUV(TU_Size_eff), TDV(TD_Size), PUP(TU_Size_eff), PDP(TD_Size), Eafe, dirv);
%         else
%             Psat = Psub(Ps, Pr, Ec, Ecshift, TUV(TU_Size), TDV(TD_Size_eff), PUP(TU_Size), PDP(TD_Size_eff), Eafe, dirv);
%         end
%     end
end

