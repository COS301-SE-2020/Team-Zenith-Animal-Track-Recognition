import { RouterTestingModule } from '@angular/router/testing';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { RangerProfileCardComponent } from './ranger-profile-card.component';
import { MAT_DIALOG_DATA, MatDialogRef, MatDialog } from '@angular/material/dialog';

describe('RangerProfileCardComponent', () => {
  let component: RangerProfileCardComponent;
  let fixture: ComponentFixture<RangerProfileCardComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        RangerProfileCardComponent,
        { provide: MAT_DIALOG_DATA, useValue: {} },
        { provide: MatDialogRef, useValue: {} },
        { provide: MatDialog, useValue: {} }
      ],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });


    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(RangerProfileCardComponent);
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
      { rangerLevel: 2 },
      { rangerLevel: 4 },
      { rangerLevel: 1 },
      { rangerLevel: 2 },
      { rangerLevel: 3 },
    ];
    expect(component.sort(false)).toEqual("Sorted by ranger level");
  });

  it('Should return true when openEditRangerDialog is sent token qwerty', () => {
    expect(component.openEditRangerDialog("qwerty")).toBeFalsy();
  });

  it('Should return false when openEditRangerDialog is sent token te57ca53t0t3s7a11ex7r3me71e5', () => {
    expect(component.openEditRangerDialog("te57ca53t0t3s7a11ex7r3me71e5")).toBeFalsy();
  });

  it('Should return true when openDeleteRangerDialog is sent token qwerty', () => {
    expect(component.openDeleteRangerDialog("qwerty")).toBeFalsy();
  });

  it('Should return false when openDeleteRangerDialog is sent token te57ca53t0t3s7a11ex7r3me71e5', () => {
    expect(component.openDeleteRangerDialog("te57ca53t0t3s7a11ex7r3me71e5")).toBeFalsy();
  });

  it('Rangers should equal "Current Zenith" when printOut is called', () => {
    component.printOut("Current Zenith");
    expect(component.rangers).toBe("C");
  });
});
