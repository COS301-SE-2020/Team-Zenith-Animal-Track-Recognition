import { MatDialog, MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { RouterTestingModule } from '@angular/router/testing';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalInfoCardComponent } from './animal-info-card.component';
import { HttpTestingController, HttpClientTestingModule } from '@angular/common/http/testing';
import { FormBuilder } from '@angular/forms';

describe('AnimalInfoCardComponent', () => {
  let component: AnimalInfoCardComponent;
  let fixture: ComponentFixture<AnimalInfoCardComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        AnimalInfoCardComponent,
        { provide: MAT_DIALOG_DATA, useValue: {} },
        { provide: MatDialogRef, useValue: {} },
        { provide: FormBuilder, useValue: {} },
        { provide: MatDialog, useValue: {} }],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });


    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(AnimalInfoCardComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Test return true', () => {
    expect(true).toBeTruthy();
  });


});
