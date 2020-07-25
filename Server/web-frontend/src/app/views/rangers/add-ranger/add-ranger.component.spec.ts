import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { FormBuilder, FormGroup } from '@angular/forms';
import { RouterTestingModule } from '@angular/router/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { MAT_DIALOG_DATA, MatDialogRef, MatDialog } from '@angular/material/dialog';

import { AddRangerComponent } from './add-ranger.component';

describe('AddRangerComponent', () => {
  let component: AddRangerComponent;
  let fixture: ComponentFixture<AddRangerComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        AddRangerComponent,
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
    component = TestBed.get(AddRangerComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Loading should be false', () =>{
    expect(component.loading).toBeFalsy();
  });

  it('Submitted should be false', () =>{
    expect(component.submitted).toBeFalsy();
  });

  it('On submit should return true on successful execution', () =>{
    expect(component.onSubmit(true)).toBeTruthy();
  });
});
