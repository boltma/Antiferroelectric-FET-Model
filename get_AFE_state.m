function [vafe, Psat, ids] = get_AFE_state(time, volt, vd, vs)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
    
    % parameter
    T = 300; %temperature, K
    Na = 3e17; %substrate doping
    til = 1e-7; %interlayer thickness
    epiv = 8.85e-14;
    miu = 50;
    W = 1;
    L = 1;
    VFB = 0;
    
    
    % start the simulation
    Ps = 6.4e-6;
    Pr = 6.34e-6;
    Ec = 1.12e6;
    Ecshift = 2.39e6;
    tfe = 1e-7;
    eafe = 33.70;

    dirv = -1;
    dirv_pre = -1;
    Psat = zeros(length(time), 1);
    vafe = zeros(length(time), 1);
    ids = zeros(length(time), 1);

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
    
    v_pre = volt(1);
    P = 0;

    for indii=1:length(time) %if the current time does not exceed the total time, keeps the simulation
        vcurr = volt(indii);
        Pstate_pre = P;
        
        %% time step determination
        if indii > 1
            if volt(indii) - volt(indii-1) > 1e-8
                dirv = 1;
            elseif volt(indii) - volt(indii-1) < -1e-8
                dirv = -1;
            else
                dirv = dirv_pre;
            end
        end
        
        F = @(x) Pstate(Ps, Pr, Ec, Ecshift, tfe, v_pre, x, dirv_pre, dirv, Pstate_pre, Es, TUV, TDV, PUP, PDP, TU_Size, TD_Size, TU_Size_eff, TD_Size_eff, flagu, flagd) + epiv * eafe / tfe * x - ...
            MOSFET_Qmos(til, Na, T, W, L, vcurr - x, VFB, vd(indii), vs(indii));
%         disp(v_pre);
        disp(indii);
        v = fzero(F, v_pre);
        [P, TUV, TDV, PUP, PDP, TU_Size, TD_Size, TU_Size_eff, TD_Size_eff, flagu, flagd] = Pstate_ret(Ps, Pr, Ec, Ecshift, tfe, v_pre, v, dirv_pre, dirv, Pstate_pre, Es, TUV, TDV, PUP, PDP, TU_Size, TD_Size, TU_Size_eff, TD_Size_eff, flagu, flagd);
        
        ids(indii) = MOSFET_ID(til, miu, Na, T, W, L, vcurr - v, VFB, vd(indii), vs(indii));
        
        dirv_pre = dirv;
        Psat(indii) = P;
        vafe(indii) = v;
        v_pre = v;
        
    end
    

end

