import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RangersComponent } from './rangers.component';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

describe('RangersComponent', () => {
  let component: RangersComponent;
  let fixture: ComponentFixture<RangersComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [RangersComponent],
      imports: [
        HttpClientTestingModule
      ]
    });


    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(RangersComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
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
      { accessLevel: 2 },
      { accessLevel: 4 },
      { accessLevel: 1 },
      { accessLevel: 2 },
      { accessLevel: 3 },
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
      { accessLevel: 2 },
      { accessLevel: 4 },
      { accessLevel: 1 },
      { accessLevel: 2 },
      { accessLevel: 3 },
    ];
    component.toggle(false);
    expect(component.sorted).toEqual("Sorted by ranger level");
  });

});
