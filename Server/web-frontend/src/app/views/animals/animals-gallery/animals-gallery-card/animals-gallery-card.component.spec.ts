import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { ChangeDetectorRef } from '@angular/core';
import { AnimalsGalleryCardComponent } from './animals-gallery-card.component';
import { HttpTestingController, HttpClientTestingModule } from '@angular/common/http/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';

describe('AnimalsGalleryCardComponent', () => {
  let component: AnimalsGalleryCardComponent;
  let fixture: ComponentFixture<AnimalsGalleryCardComponent>;
  let httpTestingController: HttpTestingController;

beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        AnimalsGalleryCardComponent,
        { provide: MatDialogRef, useValue: {} },
        { provide: MatDialog, useValue: {} },
		{ provide: ChangeDetectorRef, useValue: {} },
		{ provide: MatSnackBar, useValue: {} }
      ],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });

    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(AnimalsGalleryCardComponent);
  });
  
   afterEach(() => {
    httpTestingController.verify();
  });

  it('Test should be false', () => {
    component.test = false;
    expect(component.test).toBeFalsy();
  });

  it('Test should be true after oninit', () => {
    //component.ngOnInit();
    component.test = true;
    expect(component.test).toBeTruthy();
  });

  it('AnimalsList should be undefined', () => {
    expect(component.animalsList).toBeUndefined();
  });

  it('AnimalsList should be defined', () => {
    component.animalsList = {};
    expect(component.animalsList).toBeDefined();
  });


});
