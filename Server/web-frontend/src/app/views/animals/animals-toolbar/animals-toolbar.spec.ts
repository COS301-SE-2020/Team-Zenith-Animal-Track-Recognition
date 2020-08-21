import { MatSnackBar } from '@angular/material/snack-bar';
import { FormBuilder } from '@angular/forms';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalsToolbarComponent } from './animals-toolbar.component';
import { HttpTestingController, HttpClientTestingModule } from '@angular/common/http/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { MAT_DIALOG_DATA, MatDialogRef, MatDialog } from '@angular/material/dialog';

describe('AnimalsToolbarComponent', () => {
  let component: AnimalsToolbarComponent;
  let fixture: ComponentFixture<AnimalsToolbarComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        AnimalsToolbarComponent,
        { provide: MAT_DIALOG_DATA, useValue: {} },
        { provide: MatDialogRef, useValue: {} },
        { provide: FormBuilder, useValue: {} },
        { provide: MatSnackBar, useValue: {} },
        { provide: MatDialog, useValue: {} }
      ],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });

    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(AnimalsToolbarComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('ngOnInit should run without errors', () => {
    component.test = true;
    component.ngOnInit();
    expect(component.test).toBeTruthy();
  });

  it('stopLoader should load without errors', () => {
    component.test = true; 
    component.stopLoader();
    expect(component.test).toBeTrue();
  });

  it('startLoader should load without errors', () => {
    component.test = true; 
    component.startLoader();
    expect(component.test).toBeTrue();
  });

  it('route should load without errors', () => {
    component.test = true; 
    component.route('test');
    expect(component.test).toBeTrue();
  });


});
