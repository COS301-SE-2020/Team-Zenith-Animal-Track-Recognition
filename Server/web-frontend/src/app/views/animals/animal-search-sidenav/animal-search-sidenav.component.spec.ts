import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalSearchSidenavComponent } from './animal-search-sidenav.component';
import { HttpTestingController, HttpClientTestingModule } from '@angular/common/http/testing';
import { RouterTestingModule } from '@angular/router/testing';

describe('AnimalSearchSidenavComponent', () => {
  let component: AnimalSearchSidenavComponent;
  let fixture: ComponentFixture<AnimalSearchSidenavComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [AnimalSearchSidenavComponent],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });


    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(AnimalSearchSidenavComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Test return true', () => {
    expect(true).toBeTruthy();
  });


});
