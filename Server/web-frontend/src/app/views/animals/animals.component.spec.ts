import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalsComponent } from './animals.component';
import { HttpTestingController, HttpClientTestingModule } from '@angular/common/http/testing';
import { RouterTestingModule } from '@angular/router/testing';

describe('AnimalsComponent', () => {
  let component: AnimalsComponent;
  let fixture: ComponentFixture<AnimalsComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [AnimalsComponent],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });

    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(AnimalsComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Test should be false', () => {
    component.test = false;
    expect(component.test).toBeFalsy();
  });

  it('Test should be true after oninit', () => {
    //component.ngOnInit();
    component.test = true;
    expect(component.test).toBeTruthy();
  });

  it('Animals should be undefined', () => {
    expect(component.animals).toBeUndefined();
  });

  it('Animals should be defined', () => {
    component.animals = {};
    expect(component.animals).toBeDefined();
  });

  it('currentAlphabet should be undefined', () => {
    expect(component.currentAlphabet).toBeUndefined();
  });

  it('Animals should be defined', () => {
    component.currentAlphabet = {};
    expect(component.currentAlphabet).toBeDefined();
  });

  it('Surnames should be true', () => {
    expect(component.surnames).toBeTruthy();
  });

  it('Levels should be false', () => {
    expect(component.levels).toBeFalsy();
  });

  it('Sort by common name should be true', () => {
    expect(component.sortByCommonName).toBeTruthy();
  });

  it('Search text should be defined', () => {
    component.searchText = "Ranger";
    expect(component.searchText).toBeDefined();
  });

  it('Search text should be undefined', () => {
    expect(component.searchText).toBeUndefined();
  });

  it('ngOnInit should run', () => {
    component.ngOnInit();
    expect(component.test).toBeTruthy();
  });

  it('openSidenav should run', () => {
    component.openSidenav();
    expect(component.test).toBeTruthy();
  });

  it('closeSidenav should run', () => {
    component.closeSidenav();
    expect(component.test).toBeTruthy();
  });

  it('updateAnimalList should run', () => {
    component.updateAnimalList('te57ca53t0t3s7a11ex7r3me71e5');
    expect(component.test).toBeTruthy();
  });

  it('updateAnimalList should fail', () => {
    component.updateAnimalList('te57ca53t0t3s7a11ex7r3me71e5ft');
    expect(component.test).toBeFalse();
  });

  it('refresh should run', () => {
    component.refresh('te57ca53t0t3s7a11ex7r3me71e5');
    expect(component.test).toBeTruthy();
  });

  it('refresh should fail', () => {
    component.refresh('te57ca53t0t3s7a11ex7r3me71e5ft');
    expect(component.test).toBeFalse();
  });

  it('Should return sorted common name when sort sent true', () => {
    component.animals = [
      { commonName: '2' },
      { commonName: '4' },
      { commonName: '1' },
      { commonName: '2' },
      { commonName: '3' },
    ];
    expect(component.sort(true)).toEqual("Sorted common name");
  });

  it('Should return sorted group name when sort sent true', () => {
    component.animals = [
      { groupID: [{ groupName: 2 }] },
      { groupID: [{ groupName: 2 }] },
      { groupID: [{ groupName: 2 }] },
      { groupID: [{ groupName: 2 }] },
      { groupID: [{ groupName: 2 }] },
    ];
    expect(component.sort(false)).toEqual("Sorted group name");
  });
});
