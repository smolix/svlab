hiphys_config_5;
dotname = display(DOT);

RegulLength = length(regul_iter);

for i = 1:RegulLength
  regul = regul_iter(i);
  Regularization = RegulTemplate * regul;

  filename = [problem, '_', dotname, '_regul_', num2str(regul)];
  filename = [filename, '.mat'];
  filename = [save_path, filename];
  
  disp(['Processing file: ', filename]);

  if (i > 1)
    oldregul = regul_iter(i-1);
    oldfilename = [problem, '_', dotname, '_regul_', num2str(oldregul)];
    oldfilename = [oldfilename, '.mat'];
    oldfilename = [save_path, oldfilename];

    if ((fexist(filename) == 0) & (fexist(oldfilename) == 1))
      fprintf('creating starting point for new problem ... ');
      
      load(oldfilename);
      temp = not(Pr_Alpha == 0);
      Pr_Alpha = Pr_Alpha * regul/oldregul; % scale them proportionally
      mask = Pr_Alpha > (Regularization' - 1e-14);
      Pr_Alpha(mask) = Regularization(mask);% avoid roundoff error
      Pr_B = Pr_B * regul/oldregul;
      Pr_Error = sv_mult(DOT, patterns_train, patterns_train(:,temp), ...
	  Pr_Alpha(temp) .* polarities_train(temp)) - Pr_B - polarities_train;
      fprintf('... saving data ');
      save(filename, 'Pr_DptDiagonal', 'Pr_Alpha', 'Pr_Error', 'Pr_B');
      fprintf('done\n');
    end;
  end;
  [alpha, b, error] = PrPlatt(DOT, patterns_train, ...
      polarities_train, Regularization, filename);
  fprintf('optimization converged\n');
end;
quit;
