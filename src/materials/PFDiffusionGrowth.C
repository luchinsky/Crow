#include "PFDiffusionGrowth.h"
#include "AddV.h"

template<>
InputParameters validParams<PFDiffusionGrowth>()
{
  InputParameters params = validParams<Material>();
  params.addParam<Real>("Dvol", 0.01, "Volumetric diffusion ");
  params.addParam<Real>("Dvap", 0.001, "Vapor Diffusion ");
  params.addParam<Real>("Dsurf", 4, "surface diffusion");
  params.addParam<Real>("Dgb", 0.4, "Grain Boundary diffusion");
  //params.addParam<Real>("beta", 1.0, "The beta multiplier for the interfacial energy");
  params.addParam<Real>("kappa", 1.0, "The kappa multiplier for the interfacial energy");
  //params.addParam<Real>("L", 1.0, "The Allen-cahn multiplier");
  params.addRequiredCoupledVar("rho","phase field variable");
  params.addRequiredCoupledVar("v","array of order parameters");
  params.addRequiredParam<unsigned int>("op_num", "number of grains");
  params.addRequiredParam<std::string>("var_name_base", "base for variable names");

  return params;
}

PFDiffusionGrowth::PFDiffusionGrowth(const std::string & name,
                       InputParameters parameters) :
    Material(name, AddV(parameters)),
    _Dvol(getParam<Real>("Dvol")),
    _Dvap(getParam<Real>("Dvap")),
    _Dsurf(getParam<Real>("Dsurf")),
    _Dgb(getParam<Real>("Dgb")),
    //_beta(getParam<Real>("beta")),
    _kappa(getParam<Real>("kappa")),
    //_l(getParam<Real>("L")),
    

    _rho(coupledValue("rho")),
    _grad_rho(coupledGradient("rho")),
    _v(coupledValue("v")),

    _D(declareProperty<Real>("D")),
   // _kappa_op(declareProperty<Real>("kappa_op")),
    _kappa_c(declareProperty<Real>("kappa_c")),
    //_L(declareProperty<Real>("L")),
    _grad_D(declareProperty<RealGradient>("grad_D"))
    //_DD(declareProperty<Real>("DD")),
    //_Dgrad_Mnp(declareProperty<RealGradient>("Dgrad_Mnp")),
    //_Dgrad_Mngp(declareProperty<Real>("Dgrad_Mngp"))
    
{
  // Array of coupled variables is created in the constructor
  _ncrys = coupledComponents("v"); //determine number of grains from the number of names passed in.  Note this is the actual number -1
  _vals.resize(_ncrys); //Size variable arrays
  _vals_var.resize(_ncrys);
  
  //Loop through grains and load coupled variables into the arrays
  for (unsigned int i = 0; i < _ncrys; ++i)
  {
    _vals[i] = &coupledValue("v", i);
    _vals_var[i] = coupled("v", i);
  }
}

void
PFDiffusionGrowth::computeQpProperties()
{
    Real SumEtaj = 0.0;
    for (unsigned int i = 0; i < _ncrys; ++i)
      for (unsigned int j = 0; j < _ncrys; ++j)
      if(j!=i)
      SumEtaj += (*_vals[i])[_qp]*(*_vals[j])[_qp]; //Sum all other order parameters
  {
    Real phi = _rho[_qp]*_rho[_qp]*_rho[_qp]*(10 - 15*_rho[_qp] + 6*_rho[_qp]*_rho[_qp]);
    _D[_qp] = _Dvol* phi + _Dsurf*_rho[_qp]*(1-_rho[_qp])+ _Dgb*SumEtaj;// + _Dvap*(1 - phi) ; 
    
    RealGradient grad_phi =  30.0*_rho[_qp]*_rho[_qp]*(1 - 2*_rho[_qp] + _rho[_qp]*_rho[_qp])*_grad_rho[_qp];
    _grad_D[_qp] = _Dvol* grad_phi + _Dsurf*(1 - 2.0*_rho[_qp])*_grad_rho[_qp];// - _Dvap* grad_phi;
    
     //Real Dphi =  30.0*_rho[_qp]*_rho[_qp]*(1 - 2*_rho[_qp] + _rho[_qp]*_rho[_qp]);
    //_DD[_qp] = _Dvol* Dphi - _Dvap* Dphi + _Dsurf*(1 - 2.0*_rho[_qp]);
    
    //RealGradient Dgrad_phi =  60.0*(_rho[_qp] - 3*_rho[_qp]*_rho[_qp] + 2*_rho[_qp]*_rho[_qp]* _rho[_qp])* _grad_rho[_qp];
    //_Dgrad_Mnp[_qp] = _Dvol* Dgrad_phi - _Dvap* Dgrad_phi - 2* _Dsurf * _grad_rho[_qp];
    
    //Real Dg_phi =  60.0*(_rho[_qp] - 3*_rho[_qp]*_rho[_qp] + 2*_rho[_qp]*_rho[_qp]* _rho[_qp]);
    //_Dgrad_Mngp[_qp] = _Dvol* Dg_phi - _Dvap* Dg_phi - 2* _Dsurf;

    //_kappa_op[_qp] = _beta;
    _kappa_c[_qp] = _kappa;
    //_L[_qp] = - _l;
    
  }
}
