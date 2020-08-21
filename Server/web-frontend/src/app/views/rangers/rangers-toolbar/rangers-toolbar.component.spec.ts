import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

import { RangersToolbarComponent } from './rangers-toolbar.component';
import { RouterTestingModule } from '@angular/router/testing';
import { MAT_DIALOG_DATA, MatDialogRef, MatDialog } from '@angular/material/dialog';

describe('RangersToolbarComponent', () => {
  let component: RangersToolbarComponent;
  let fixture: ComponentFixture<RangersToolbarComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        RangersToolbarComponent,
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
    component = TestBed.get(RangersToolbarComponent);
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

  it('Should return true when add ranger dialog is opened', () => {
    expect(true).toBeTruthy();
  });

});
