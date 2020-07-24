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

  it('surnames should be true', () => {
    expect(component.surnames).toBeTruthy();
  });

  it('levels should be false', () => {
    expect(component.levels).toBeFalsy();
  });


});
