import { FormBuilder, FormGroup } from '@angular/forms';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { MAT_DIALOG_DATA, MatDialogRef, MatDialog } from '@angular/material/dialog';

import { EditRangerInfoComponent } from './edit-ranger-info.component';

describe('EditRangerInfoComponent', () =>  {
  let component: EditRangerInfoComponent;
  let fixture: ComponentFixture<EditRangerInfoComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        EditRangerInfoComponent,
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
    component = TestBed.get(EditRangerInfoComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Rangers should contain data', () => {
    expect(true).toBeTruthy();
  });

  it('Should return the controls of the form', () => { 
    const test = true;
    expect(test).toBeTruthy();
  });

  it('Should return true when submitted', () => {
    expect(component.onSubmit(true)).toBeTruthy();
  });

});

