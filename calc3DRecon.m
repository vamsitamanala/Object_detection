function PW = calc3DRecon(P1,P2,M1,M2)
[K1,R1,O1] = KRO_PPM(M1);
[K2,R2,O2] = KRO_PPM(M2);
P1W = (K1*R1)\P1;
P2W = (K2*R2)\P2;
jVal = cross(P1W,P2W)/norm(cross(P1W,P2W));
P = [P1W P2W jVal];
t = O2-O1;
K = P\t;
PW = O1+ (K(1)*P1W) + ((K(3)/2)*jVal);
end