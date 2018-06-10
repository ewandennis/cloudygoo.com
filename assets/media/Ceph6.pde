import processing.opengl.*;

// ----------------------------------------------------------------------------

float runit() {
  float r = random(1);
  if (r > 0.5) return 1;
  return -1;
}
// ----------------------------------------------------------------------------


public class TendrilParams {
  public TendrilParams() {
    x = 0;
    y = 0;
    stepsize = 8;
    thicknessA = 64;
    thicknessB = 2;
    curvelen = 500;
    curvelenvariance = 0.2;
    curvewidth = 50;
    seedPtRepulsionA = 0.04;
    seedPtRepulsionB = 0.1;
    seedPts = new TentacleSeedPts(15, width/7, 1);
    dir = new PVector();
    PVector.random2D(dir);
  }

  public TendrilParams(float _x, float _y, PVector _dir, float _curvelen, float _stepsize, 
  float _thicknessA, float _thicknessB, float _curvelenvariance, float _curvewidth, TentacleSeedPts _seedPts, float _seedPtRepulsionA, float _seedPtRepulsionB)
  {
    x = _x;
    y = _y;
    dir = _dir;
    stepsize = _stepsize;
    thicknessA = _thicknessA;
    thicknessB = _thicknessB;
    curvelen = _curvelen;
    curvelenvariance = _curvelenvariance;  
    curvewidth = _curvewidth;
    seedPts = _seedPts;
    seedPtRepulsionA = _seedPtRepulsionA;
    seedPtRepulsionB = _seedPtRepulsionB;
  }

  public TendrilParams(TendrilParams _rhs) {
    x = _rhs.x;
    y = _rhs.y;
    dir = _rhs.dir;
    stepsize = _rhs.stepsize;
    thicknessA = _rhs.thicknessA;
    thicknessB = _rhs.thicknessB;
    curvelen = _rhs.curvelen;
    curvelenvariance = _rhs.curvelenvariance;  
    curvewidth = _rhs.curvewidth;
    seedPts = _rhs.seedPts;
    seedPtRepulsionA = _rhs.seedPtRepulsionA;
    seedPtRepulsionB = _rhs.seedPtRepulsionB;
  }

  TendrilParams copy() { 
    return new TendrilParams(this);
  }

  public float x;
  public float y;
  public PVector dir;
  public float stepsize;
  public float thicknessA;
  public float thicknessB;
  public float curvelen;
  public float curvelenvariance;
  public float curvewidth;
  public float seedPtRepulsionA;
  public float seedPtRepulsionB;
  public TentacleSeedPts seedPts;
}

// ----------------------------------------------------------------------------

public class SuckerParams {
  public SuckerParams() {
    count = 32;
    radiusA = 26;
    radiusB = 8;
  }

  public int count;
  public float radiusA;
  public float radiusB;
}

// ----------------------------------------------------------------------------

public class TentacleSeedPts {
  public void vec2str(PVector v) {
    return v.x + ', ' + v.y;
  }

  public TentacleSeedPts(int _npts, float _radius, float _kick) {
    kick_ = _kick;

    int dim = round(sqrt(_npts));
    _npts = dim*dim;

    pts_ = new PVector[_npts];
    dirs_ = new PVector[_npts];
    radii_ = new float[_npts];
    
    dir_ = 1;

    int xdim = width/dim;
    int ydim = height/dim;
    for (int y = 0; y < dim; ++y) {
      for (int x = 0; x < dim; ++x) {
        int idx = y*dim + x;
        // PVector p = PVector.random2D(app);
        PVector p = new PVector();
        PVector.random2D(p);
        p.x = width*0.5 + (p.x * width * random(0.5));
        p.y = (height*0.5) + (p.y * height * random(0.5));
        pts_[idx] = p;
        // dirs_[idx] = PVector.random2D(app);
        dirs_[idx] = new PVector();
        PVector.random2D(dirs_[idx]);
        radii_[idx] = _radius;
      }
    }
  }
  
  bool hit = false;

  PVector getFieldDirection(PVector _pos) {
    PVector dir = new PVector();
    for (int j = 0; j < pts_.length; ++j) {
      PVector p = pts_[j];
      float d = p.dist(_pos);
  
      float r = radii_[j];
      float r2 = r * r;
      int n = 0;
      if (d < r) {
        PVector seedptdir = PVector.sub(p, _pos);
        float dist = seedptdir.mag();
        seedptdir.normalize();
        seedptdir.mult(1 / r2);
        dir.add(seedptdir);
        ++n;
      }
      
//      if (n > 4) {
//        break;
//      }
    }
  
    dir.normalize();
    return dir;
  }
  
  public void tick() {
    for (int j = 0; j < pts_.length; ++j) {
      PVector p = pts_[j];
      PVector d = dirs_[j];
      
      p.x -= width / 2;
      p.y -= height / 2;
      p.rotate(random(0.001) * 2 * PI);
      p.x += width / 2;
      p.y += height / 2;
      
      if (ticks_++ % 100 == 0) {
        d = new PVector();
        PVector.random2D(p);
      }
    }
  }

  // public void draw() {
  //   noStroke();
  //   for (int i = 0; i < pts_.length; ++i) {
  //     fill(31, 31, 31);
  //     ellipse(pts_[i].x, pts_[i].y, radii_[i], radii_[i]);
  //   }
  // }

  public void draw() {
    stroke(127, 127, 127);
    for (int i = 0; i < pts_.length; ++i) {
      fill(31, 31, 31);
      ellipse(pts_[i].x, pts_[i].y, radii_[i], radii_[i]);
      noFill();
      ellipse(pts_[i].x, pts_[i].y, 4, 4);
    }
  }

  PVector pts_[];
  PVector dirs_[];
  float radii_[];
  float dir_;
  int ticks_;
  float kick_;
}

// ----------------------------------------------------------------------------

public class Tentacle {

  class Pt {
    public PVector pos;
    public PVector side;
  }

  // ----------------------------------------------------------------------------

  class Sucker {
    public PVector pos;
    float radius;
  };

  // ----------------------------------------------------------------------------

  class CurveWalkState {
    void dump() {
      print("ptidx = " + ptidx + "\n");
      print("t = " + t + "\n\n");
    }

    int ptidx;
    float t;
  }

  // ----------------------------------------------------------------------------

  Tentacle(TendrilParams _tparams, SuckerParams _sparams) {
    tparams_ = _tparams;
    sparams_ = _sparams;

    float curvelen = _makeTendril(_tparams);

    _makeSuckers(_sparams, curvelen);
  }

  // ----------------------------------------------------------------------------

  float _makeTendril(TendrilParams _tparams) {
    PVector pos = new PVector(_tparams.x, _tparams.y);
    PVector lastpos = new PVector(_tparams.x, _tparams.y);
    PVector basedir = new PVector();
    basedir.set(_tparams.dir);

    float ideallen = _tparams.curvelen + (random(_tparams.curvelenvariance) * _tparams.curvelen);
    int steps = round(ideallen / _tparams.stepsize);

    float curvelen = 0;

    pts_ = new Pt[steps];
    dirs_ = new PVector[steps];

    for (int i = 0; i < steps; ++i) {
      float t = (float)i / (float)steps;
      float thickness = lerp(_tparams.thicknessA, _tparams.thicknessB, t);
      float seedPtRepulsion = lerp(_tparams.seedPtRepulsionA, _tparams.seedPtRepulsionB, t);

      PVector dir = _tparams.seedPts.getFieldDirection(lastpos);

      basedir.lerp(dir, seedPtRepulsion * _tparams.stepsize);
      basedir.normalize();
      basedir.mult(_tparams.stepsize);

      dirs_[i] = new PVector(basedir.x, basedir.y);

      pos = new PVector(lastpos.x + basedir.x, lastpos.y + basedir.y);

      pts_[i] = new Pt();
      pts_[i].pos = pos;

      PVector ab = new PVector(pos.x, pos.y);
      ab.sub(lastpos);

      if (i > 0) {
        curvelen += ab.mag();
      }

      PVector side = ab.cross(new PVector(0, 0, 1));
      side.normalize();
      side.mult(thickness/2);

      pts_[i].side = new PVector();
      pts_[i].side.set(side);

      lastpos.set(pos);
    }

//    print("ideal len = " + ideallen + " curvelen = " + curvelen + "\n");
    return curvelen;
  }

  void _makeSuckers(SuckerParams _sparams, float _curvelen) {
    suckers_ = new Sucker[_sparams.count];
    float suckerseparation = _curvelen / _sparams.count; 
    CurveWalkState walkState = new CurveWalkState();
    walkState.ptidx = 0;

    for (int j = 0; j < _sparams.count; ++j) {
      float t = (float)j / (float)_sparams.count;

      PVector pos = _walkCurve(pts_, walkState, suckerseparation);
      PVector offs = new PVector();
      offs.set(pts_[walkState.ptidx].side);
      offs.mult(0.5);
      if (j % 2 == 0) {
        pos.add(offs);
      } 
      else {
        pos.sub(offs);
      }

      suckers_[j] = new Sucker();
      suckers_[j].pos = pos;
      suckers_[j].radius = lerp(_sparams.radiusA, _sparams.radiusB, t);
    }
  }

  PVector _walkCurve(Pt _pts[], CurveWalkState _state, float stepLen) {
    float curLen = 0;

    if (_state.ptidx < _pts.length-2) {
      PVector a = _pts[_state.ptidx].pos;
      PVector b = _pts[_state.ptidx+1].pos;

      curLen = 0;
      float d = a.dist(b) * (1.0 - _state.t);

      while (_state.ptidx < _pts.length-2) {

        if (curLen + d > stepLen) {
          _state.t = (stepLen - curLen) / d;
          return PVector.lerp(a, b, _state.t);
        }

        curLen += d;
        ++_state.ptidx;

        a = _pts[_state.ptidx].pos;
        b = _pts[_state.ptidx+1].pos;
        d = a.dist(b);
      }
    }

    // Fallthrough from curve walk _and_ outer array bounds guard

    PVector ret = new PVector();
    ret.set(_pts[_pts.length-1].pos);
//    print("WARN: _walkCurve running off the end of the curve\n");
//    print("stepLen = " + stepLen + "\n");
//    print("curLen = " + curLen + "\n");
    return ret;
  }

  void drawDirs() {
    noFill();
    stroke(255, 255, 0);
    beginShape(LINES);
    for (int i = 1; i < dirs_.length; ++i) {
      vertex(pts_[i].pos.x, pts_[i].pos.y);
      vertex(pts_[i].pos.x + (dirs_[i].x * 4), pts_[i].pos.y + (dirs_[i].y * 4));
    }
    endShape();
  }

  void drawWire() {
    noFill();
    beginShape(LINES);
    for (int i = 1; i < pts_.length; ++i) {
      Pt p0 = pts_[i-1];
      Pt p1 = pts_[i];
      vertex(p0.pos.x, p0.pos.y);
      vertex(p1.pos.x, p1.pos.y);
      vertex(p1.pos.x-p1.side.x, p1.pos.y-p1.side.y);
      vertex(p1.pos.x+p1.side.x, p1.pos.y+p1.side.y);
    }
    endShape();
  }

  void drawPts() {
    fill(255, 255, 255);
    for (int i = 1; i < pts_.length; ++i) {
      PVector p = pts_[i].pos;
      ellipse(p.x, p.y, 6, 6);
    }
  }

  void draw() {
    fill(32, 64, 255);
    stroke(32, 64, 255);

    Pt p0 = pts_[0];
    beginShape(QUAD_STRIP);
    vertex(p0.pos.x-p0.side.x, p0.pos.y-p0.side.y);
    vertex(p0.pos.x+p0.side.x, p0.pos.y+p0.side.y);

    for (int i = 1; i < pts_.length; ++i) {
      Pt p = pts_[i];
      vertex(p.pos.x-p.side.x, p.pos.y-p.side.y);
      vertex(p.pos.x+p.side.x, p.pos.y+p.side.y);
    }

    endShape();
  }

  void drawOutlines() {
    noFill();
    stroke(255, 255, 255);
    for (int i = 2; i < pts_.length; ++i) {
      Pt p0 = pts_[i-1];
      Pt p1 = pts_[i];
      beginShape(LINES);
      vertex(p0.pos.x-p0.side.x, p0.pos.y-p0.side.y);
      vertex(p1.pos.x-p1.side.x, p1.pos.y-p1.side.y);
      vertex(p0.pos.x+p0.side.x, p0.pos.y+p0.side.y);
      vertex(p1.pos.x+p1.side.x, p1.pos.y+p1.side.y);
      endShape();
    }
  }

  void drawSuckers() {
    fill(30, 70, 96);
    stroke(30, 70, 96);
    for (int i = 0; i < suckers_.length; ++i) {
      PVector pos = suckers_[i].pos;
      float radius = suckers_[i].radius;
      ellipse(pos.x, pos.y, radius, radius);
    }
  }

  // ----------------------------------------------------------------------------

  TendrilParams tparams_;
  SuckerParams sparams_;

  Pt pts_[];

  Sucker suckers_[];

  PVector dirs_[];
}

// ----------------------------------------------------------------------------

TendrilParams tparams;

SuckerParams sparams;

TentacleSeedPts seedPts;

Tentacle tentacles[];
Tentacle newtentacles[];

PApplet app;

// ----------------------------------------------------------------------------

void setup() {
  app = this;
  // size(round(displayHeight*0.9), round(displayHeight*0.9));
  size(500, 500)
  frameRate(30);

  randomSeed(100);

  seedPts = new TentacleSeedPts(32, 96, 0.25);

  tparams = new TendrilParams();
  tparams.seedPts = seedPts;
  tparams.thicknessA = 32;
  tparams.thicknessB = 2;
  tparams.curvelen = 300;

  sparams = new SuckerParams();
  sparams.count = 48;
  sparams.radiusA = 12;
  sparams.radiusB = 2;

  tentacles = makeoctopus();
  tparams.seedPts.tick();
  newtentacles = makeoctopus();

  strokeWeight(1);
  smooth();
}

Tentacle[] makeoctopus() {
  randomSeed(101);
  Tentacle ret[] = new Tentacle[8];
  for (int i = 0; i < ret.length; ++i) {
    float t = (float)i / (float)ret.length;

    PVector cdir = new PVector(0, 1);
    cdir.rotate(t * PI * 2);

    TendrilParams p = tparams.copy();
    p.x = (width/2) + (cdir.x * width / 16);
    p.y = (height/2) + (cdir.y * width / 16);
    p.dir.set(cdir);

    ret[i] = new Tentacle(p, sparams);
  }
  
  return ret;
}

void tickoctopus() {
  tparams.seedPts.tick();
  tentacles = makeoctopus();
}

void draw() {
  background(0.0);

  tickoctopus();

  tparams.seedPts.draw();

    // fill(32, 64, 255);
    // stroke(32, 64, 255);
    // ellipse(width/2, height/2, 90, 90);

  for (int i = 0; i < tentacles.length; ++i) {
    Tentacle t = tentacles[i];

    // t.drawDirs();
    // t.drawPts();
    // t.drawWire();
    t.drawOutlines();
    // t.drawSuckers();
  }
}

// ----------------------------------------------------------------------------

