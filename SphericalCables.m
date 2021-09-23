
close all; clear; clc; radiusEarth=6371;

load PolyLattice.mat;
load polyArray.mat;

PolyLattice=PolyLattice(1:5:end,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Equator=(-180:1:180)';
Equator=cat(2,Equator,zeros(length(Equator),1));

PrimeMeridian=(-90:1:90)';
PrimeMeridian=cat(2,zeros(length(PrimeMeridian),1),PrimeMeridian);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Position',[120,60,1420,780],'Color','k');
hold on; axis off; axis tight;
scatter(PolyLattice(:,1),PolyLattice(:,2),0.1);
plot(Equator(:,1),Equator(:,2),'c');
plot(PrimeMeridian(:,1),PrimeMeridian(:,2),'c');

for i = 1:max(polyArray(:,3))
    
    bundleIndex = find(polyArray(:,3) == i);
    bundle = polyArray(bundleIndex,:);
    
    for j = 1:max(bundle(:,3))
        
        cableIndex = find(bundle(:,4) == j);
        cable = bundle(cableIndex,1:2);
        
        plot(cable(:,1),cable(:,2),'w','LineWidth',0.1);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radX=deg2rad(PolyLattice(:,1));
radY=deg2rad(PolyLattice(:,2));
[X,Y,Z]=sph2cart(radX,radY,radiusEarth);

radX=deg2rad(Equator(:,1));
radY=deg2rad(Equator(:,2));
[iaX,iaY,iaZ]=sph2cart(radX,radY,7000);

radX=deg2rad(PrimeMeridian(:,1));
radY=deg2rad(PrimeMeridian(:,2));
[ibX,ibY,ibZ]=sph2cart(radX,radY,7000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Position',[120,60,800,800],'Color','k'); view(33,33);
set(gca,'CameraViewAngleMode','manual');
hold on; axis off; axis tight;

scatter3(X,Y,Z,0.1);

plot3(iaX,iaY,iaZ,'c');
plot3(ibX,ibY,ibZ,'c');
plot3(ibX*-1,ibY,ibZ*-1,'c');

for i = 1:max(polyArray(:,3))
    
    bundleIndex = find(polyArray(:,3) == i);
    bundle = polyArray(bundleIndex,:);
    
    for j = 1:max(bundle(:,3))
        
        cableIndex = find(bundle(:,4) == j);
        cable = bundle(cableIndex,1:2);
        
        radX=deg2rad(cable(:,1));
        radY=deg2rad(cable(:,2));
        [iX,iY,iZ]=sph2cart(radX,radY,radiusEarth);
        
        plot3(iX,iY,iZ,'w');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




