%solve the smaller problem (upper left block) first
c1 = [A(:,1:n)' c_x(1:n,:)];
c2 = [A(:,(n+1):nn)' c_x((n+1):nn,:)];
c_plus = c1 + c2;
c_minus = c1 - c2;

D1 = d(1:n);
D2 = d((n+1):nn);

%diagonal terms
T_plus  = 0.5 * (D1 + D2);
T_minus = 0.5 * (D1 - D2);
T       = 1 ./ (2 * H2 + T_plus);
TTminus = T .* T_minus;
T_diag  = H1_diag + 0.5 * (T_plus - T_minus .* TTminus);

for i = 1:(j + 1)
	rhs_int(:,i) = 0.5 * (c_minus(:,i) - TTminus .* c_plus(:,i));
end

for i = 1:n
	H1(i,i) = T_diag(i);
end
R = chol(H1);
Hx_AC_minus = R \ (rhs_int' / R)';

for i = 1:(j + 1)
	Hx_AC_plus(:,i) = T .* (c_plus(:,i) - T_minus .* Hx_AC_minus(:,i));
end

Hx_AC = 0.5 * [(Hx_AC_plus + Hx_AC_minus); (Hx_AC_plus - Hx_AC_minus)];
A_Hx_AC = A * Hx_AC;

%split up the indices and substitute back
Hx_A = Hx_AC(:,1:j);
Hx_C = Hx_AC(:,j+1);
A_Hx_A = A_Hx_AC(:,1:j);
A_Hx_C = A_Hx_AC(:,j+1);

x_y = (A_Hx_A + H_y) \ (c_y + A_Hx_C);
x_x = (Hx_A * x_y) - Hx_C;

