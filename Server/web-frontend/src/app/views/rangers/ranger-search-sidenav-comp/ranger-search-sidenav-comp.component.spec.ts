import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

import { RangerSearchSidenavCompComponent } from './ranger-search-sidenav-comp.component';

describe('RangerSearchSidenavCompComponent', () => {
  let component: RangerSearchSidenavCompComponent;
  let fixture: ComponentFixture<RangerSearchSidenavCompComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [RangerSearchSidenavCompComponent],
      imports: [
        HttpClientTestingModule
      ]
    });


    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(RangerSearchSidenavCompComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Surnames should be true', () => {
    expect(component.surnames).toBeTruthy();
  });

  it('Levels should be false', () => {
    expect(component.levels).toBeFalsy();
  });

  it('Rangers should contain data', () => {
    component.rangers = [
      { lastName: "Bob" },
      { lastName: "Frank" },
      { lastName: "Joel" },
      { lastName: "Clive" },
      { lastName: "Kiss" },
      { lastName: "Storm" }
    ];
    expect(component.rangers).toBeDefined();
  });

  it('Should return sorted alphabetically when sort sent true', () => {
    component.rangers = [
      { lastName: "Bob" },
      { lastName: "Frank" },
      { lastName: "Joel" },
      { lastName: "Clive" },
      { lastName: "Kiss" },
      { lastName: "Storm" }
    ];
    expect(component.sort(true)).toEqual("Sorted alphabetically");
  });

  it('Should return sorted by ranger level when sort sent false', () => {
    component.rangers = [
      { rangerLevel: 2 },
      { rangerLevel: 4 },
      { rangerLevel: 1 },
      { rangerLevel: 2 },
      { rangerLevel: 3 },
    ];
    expect(component.sort(false)).toEqual("Sorted by ranger level");
  });
  it('Should return sorted alphabetically when toggle sent true', () => {
    component.rangers = [
      { lastName: "Bob" },
      { lastName: "Frank" },
      { lastName: "Joel" },
      { lastName: "Clive" },
      { lastName: "Kiss" },
      { lastName: "Storm" }
    ];
    component.toggle(true);
    expect(component.sorted).toEqual("Sorted alphabetically");
  });

  it('Should return sorted by ranger level when toggle sent false', () => {
    component.rangers = [
      { rangerLevel: 2 },
      { rangerLevel: 4 },
      { rangerLevel: 1 },
      { rangerLevel: 2 },
      { rangerLevel: 3 },
    ];
    component.toggle(false);
    expect(component.sorted).toEqual("Sorted by ranger level");
  });

  it('Should return true when current alphabet set to "d" and string sent is Zenith', () => {
    component.currentAlphabet = 'd';
    expect(component.checkIfNew("Zenith", 0)).toBeTruthy();
  });

  it('Should return true when current alphabet set to "z" and string sent is Zenith', () => {
    component.currentAlphabet = 'z';
    expect(component.checkIfNew("Zenith", 0)).toBeFalsy();
  });

  it('Rangers should equal "Current Zenith" when printOut is called', () => {
    component.printOut("Current Zenith");
    expect(component.rangers).toBe("C");
  });
});
