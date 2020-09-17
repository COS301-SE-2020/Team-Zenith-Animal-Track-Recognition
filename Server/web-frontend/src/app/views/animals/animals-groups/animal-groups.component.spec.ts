import { RouterTestingModule } from '@angular/router/testing';
import { RangerPermissionsComponent } from './animal-groups.component';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

describe('RangerPermissionsComponent', () => {
  let component: RangerPermissionsComponent;
  let fixture: ComponentFixture<RangerPermissionsComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [RangerPermissionsComponent],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });


    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(RangerPermissionsComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('permissionsColumns should exist', () => {
    expect(component.permissionsColumns).toBeDefined();
  });

  it('permissionsDataSource should exist', () => {
    expect(component.permissionsDataSource).toBeDefined();
  });

  it('rangerPermissionsColumns should exist', () => {
    expect(component.rangerPermissionsColumns).toBeDefined();
  });

  it('rangerPermissionsDataSource should exist', () => {
    component.rangerPermissionsDataSource = "hello";
    expect(component.rangerPermissionsDataSource).toBeDefined();
  });

  it('permissionsDataSource should exist', () => {
    expect(component.permissionsDataSource).toBeDefined();
  });

  it('permissionsDataSource should exist', () => {
    expect(component.permissionsDataSource).toBeDefined();
  });

  it('Sort should return true', () => {
    component.rangerPermissionsDataSource = [
      { lastName: "Frank", Access_Level: 2 },
      { lastName: "Bob", Access_Level: 1 },
      { lastName: "Dylan", Access_Level: 3 },
      { lastName: "Sea", Access_Level: 2 },
      { lastName: "Possum", Access_Level: 1 },
    ]
    expect(component.sort(true)).toBeTruthy();
  });

  it('Sort should return false', () => {
    component.rangerPermissionsDataSource = [
      { lastName: "Frank", Access_Level: 2 },
      { lastName: "Bob", Access_Level: 1 },
      { lastName: "Dylan", Access_Level: 3 },
      { lastName: "Sea", Access_Level: 2 },
      { lastName: "Possum", Access_Level: 1 },
    ]
    expect(component.sort(false)).toBeFalsy();
  });


});
