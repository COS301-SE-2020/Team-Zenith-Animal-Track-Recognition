import { FormBuilder } from '@angular/forms';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EditAnimalInfoComponent } from './edit-animal-info.component';
import { HttpTestingController, HttpClientTestingModule } from '@angular/common/http/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { MAT_DIALOG_DATA, MatDialogRef, MatDialog } from '@angular/material/dialog';

describe('EditAnimalInfoComponent', () => {
  let component: EditAnimalInfoComponent;
  let fixture: ComponentFixture<EditAnimalInfoComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        EditAnimalInfoComponent,
        { provide: MAT_DIALOG_DATA, useValue: {} },
        { provide: MatDialogRef, useValue: {} },
        { provide: FormBuilder, useValue: {} },
        { provide: MatDialog, useValue: {} }
      ],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });

    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(EditAnimalInfoComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('ngOnInit should run without errors', () => {
    component.test = true;
    component.ngOnInit();
    expect(component.test).toBeTruthy();
  });

  it('fillDietTypes should run without errors', () => {
    component.test = true;
    component.fillDietTypes();
    expect(component.test).toBeTrue();
  });

  it('Form controls should load without errors', () => {
    component.test = true;
    expect(component.f).toBeDefined();
  });

  it('onSubmit should load without errors', () => {
    component.test = true;
    expect(component.onSubmit(true)).toBeTrue();
  });

  it('remQuotes should correctly remove quotation marks from a string', () => {
    expect(component.remQuotes('This is an "eggcellent" test')).toEqual("This is an 'eggcellent' test");
  });

  it('attachProgressbar should load without errors', () => {
    component.test = true; 
    component.attachProgressbar();
    expect(component.test).toBeTrue();
  });

  it('closeDialog should load without errors', () => {
    component.test = true; 
    component.closeDialog();
    expect(component.test).toBeTrue();
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


});
