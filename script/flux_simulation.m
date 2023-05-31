clc;
clear;

%%load a model
NEWmodel=importExcelModel('iAL1006 v1.00.xlsx',false);
model = ravenCobraWrapper(NEWmodel);

%%add the reaction according to the dummy_flux
% model=addExchangeRxn(model,'ALA[c]',0,0); %alanine
 model=addExchangeRxn(model,'GLY[c]',0,0); %Glycine
model=addExchangeRxn(model,'VAL[c]',0,0); %valine
model=addExchangeRxn(model,'LEU[c]',0,0); %leucine
model=addExchangeRxn(model,'ILE[c]',0,0); %iso-leucine
model=addExchangeRxn(model,'PRO[c]',0,0); %proline
model=addExchangeRxn(model,'SER[c]',0,0); %serine
model=addExchangeRxn(model,'PHE[c]',0,0); %phenylalanine
model=addExchangeRxn(model,'ASP[c]',0,0); %aspartate
% model=addExchangeRxn(model,'GLU[c]',0,0); %glutamate
 model=addExchangeRxn(model,'ORN[c]',0,0); %ornithine
model=addExchangeRxn(model,'LYS[c]',0,0); %lysine
model=addExchangeRxn(model,'ASN[c]',0,0); %asparagine
model=addExchangeRxn(model,'TYR[c]',0,0); %Tyrosine
model=addExchangeRxn(model,'AMA[c]',0,0); %α-Aminoadipic Acid
model=addExchangeRxn(model,'SUCC[c]',0,0); %Succinate
model=addExchangeRxn(model,'FUM[c]',0,0); %Fumarate
model=addExchangeRxn(model,'MAL[c]',0,0); %malate
% model=addExchangeRxn(model,'XOL[c]',0,0); %Xylitol
% model=addExchangeRxn(model,'AOL[c]',0,0); %Arabitol
% model=addExchangeRxn(model,'CIT[c]',0,0); %Citrate
model=addExchangeRxn(model,'GLC[c]',0,0); %glucose
% model=addExchangeRxn(model,'S7P[c]',0,0); %S7P
% model=addExchangeRxn(model,'TRE[c]',0,0); %Trehalose
% model=addExchangeRxn(model,'G6P[c]',0,0); %G6P
model=addExchangeRxn(model,'AKG[c]',0,0); %akg
model=addExchangeRxn(model,'O2e[e]',0,0); %qo2

model=addExchangeRxn(model,'PAAe[e]',0.30023,0.4583925); %qPAA
model=changeRxnBounds(model,'pengOUT',0.059837,'l'); %qPenG
model=changeRxnBounds(model,'pengOUT',0.082572875,'u'); %qPenG
model=changeRxnBounds(model,'6apaOUT',0.516922,'l'); %6APA
model=changeRxnBounds(model,'6apaOUT',0.731518,'u'); %6APA
model=changeRxnBounds(model,'opcOUT',0.534596,'l'); %OPC
model=changeRxnBounds(model,'opcOUT',1.23702,'u'); %OPC


%%keep balance
%model=changeRxnBounds(model,'R1291', 0, 'b');  %% nadp[m] <=> nadph[m]
model=changeRxnBounds(model,'freeNADPH', 0, 'b');  %% nadp <=> nadph
model=changeRxnBounds(model,'ureaIN', 0, 'b');  %% urea input
model=changeRxnBounds(model,'hno3IN', 0, 'b');  %% hno3 input
    model=changeRxnBounds(model,'r0307', 0, 'b');  %% gl3p + fad <=> t3p2 + fadh2 可消除无碳源输入时有菌体生长
    %model=changeRxnBounds(model,'r1183', 0, 'b');  %% cit[m] + mal => cit + mal[m]

%%uptake and production balance glcntOUT
model=changeRxnBounds(model,'co2OUT', 4.613, 'b');
model=changeRxnBounds(model,'etohIN', 0, 'b');


%%dummy_flux
data_RAW = readmatrix("fit_result_concentration_final_new.xlsx", "Sheet","flux");
%solverOK = changeCobraSolver('ibm_cplex','LP');
solverOK = changeCobraSolver('gurobi','LP');
model=changeObjective(model, 'bmOUT')

X = zeros(1,28);
Y = zeros(150,1650);

for i = 1:1:150
    i
    X = data_RAW(i,:);

    model=changeRxnBounds(model,'dglcIN', X(1), 'b'); %qs
    model=changeRxnBounds(model,'citOUT', X(1), 'u');
    model=changeRxnBounds(model,'glcntOUT', X(1), 'u');
    model=changeRxnBounds(model,'ureaOUT', X(1), 'u');
    model=changeRxnBounds(model,'glcIN', X(1), 'u');
     %   model=changeRxnBounds(model,'EX_ALA[c]', X(2), 'b'); %alanine
          model=changeRxnBounds(model,'EX_GLY[c]', X(3), 'b'); %Glycine
    model=changeRxnBounds(model,'EX_VAL[c]', X(4), 'b'); %valine
    model=changeRxnBounds(model,'EX_LEU[c]', X(5), 'b'); %leucine
    model=changeRxnBounds(model,'EX_ILE[c]', X(6), 'b'); %iso-leucine
    model=changeRxnBounds(model,'EX_PRO[c]', X(7), 'b'); %proline
    model=changeRxnBounds(model,'EX_SER[c]', X(8), 'b'); %serine
    model=changeRxnBounds(model,'EX_PHE[c]', X(9), 'b'); %phenylalnine
    model=changeRxnBounds(model,'EX_ASP[c]', X(10), 'b'); %aspartate
% %     model=changeRxnBounds(model,'EX_GLU[c]', X(11), 'b'); %glutamate
       model=changeRxnBounds(model,'EX_ORN[c]', X(12), 'b'); %ornithine
    model=changeRxnBounds(model,'EX_LYS[c]', X(13), 'b'); %lysine
    model=changeRxnBounds(model,'EX_ASN[c]', X(14), 'b'); %asparagine
    model=changeRxnBounds(model,'EX_TYR[c]', X(15), 'b'); %Tyrosine
    model=changeRxnBounds(model,'EX_AMA[c]', X(16), 'b'); %α-Aminoadipic Acid
    model=changeRxnBounds(model,'EX_SUCC[c]', X(17), 'b'); %Succinate
    model=changeRxnBounds(model,'EX_FUM[c]', X(18), 'b'); %Fumarate
    model=changeRxnBounds(model,'EX_MAL[c]', X(19), 'b'); %malate
        %model=changeRxnBounds(model,'EX_XOL[c]', X(20), 'b'); %Xylitol
        %model=changeRxnBounds(model,'EX_AOL[c]', X(21), 'b'); %Arabitol
        %model=changeRxnBounds(model,'EX_CIT[c]', X(22), 'b'); %Citrate
    model=changeRxnBounds(model,'EX_GLC[c]', X(23), 'b'); %Glucose
        %model=changeRxnBounds(model,'EX_S7P[c]', X(24), 'b'); %S7P
        %model=changeRxnBounds(model,'EX_TRE[c]', X(25), 'b'); %Trehalose
        %model=changeRxnBounds(model,'EX_G6P[c]', X(26), 'b'); %G6P
    model=changeRxnBounds(model,'EX_AKG[c]', X(27), 'b'); %akg
    model=changeRxnBounds(model,'EX_O2e[e]', X(28), 'b');%qo2


    model=changeObjective(model, 'bmOUT');
    %model=changeObjective(model, 'biomass'); 
    sol = optimizeCbModel(model,'max','one');
    if size(sol.x) == [0 0] %#ok<*BDSCA>
        Y(i,:) = 0;
    else
        for k=1:1650
            Y(i,k) = sol.x(k);
        end
    end
end

%writematrix(Y,'F:\Flux_heatmap\flux_all_final_bmOUT_new3.xlsx');
%clc;
%plot(Y(:,1),'-');
%xlabel('time(s)');
%ylabel('flux(mmol/g/h)');
%axis([0 360 0 0.5]);
tiledlayout(6,6)
for i = 1:1:36
    nexttile
    plot(Y(:,i),'-');
    xlabel('time(s)');
    ylabel('flux(mmol/g/h)');
end
'Done'  
%writeCbModel(model,'iAL1006D.mat')
