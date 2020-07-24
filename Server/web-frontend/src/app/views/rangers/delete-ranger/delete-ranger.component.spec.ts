import { FormBuilder, FormGroup } from '@angular/forms';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { MAT_DIALOG_DATA, MatDialogRef, MatDialog } from '@angular/material/dialog';

import { DeleteRangerComponent } from './delete-ranger.component';

describe('DeleteRangerComponent', () => {
  let component: DeleteRangerComponent;
  let fixture: ComponentFixture<DeleteRangerComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        DeleteRangerComponent,
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
    component = TestBed.get(DeleteRangerComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Should return true', () =>{
    expect(component.confirmDelete(true)).toBeTruthy();
  });

  it('Should return false', () =>{
    component.ngOnInit();
    expect(component.temp).toBeFalsy();
  });
});
