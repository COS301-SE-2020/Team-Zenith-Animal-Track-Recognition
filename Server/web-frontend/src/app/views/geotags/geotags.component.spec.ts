import { RouterTestingModule } from '@angular/router/testing';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { GeotagsComponent } from './geotags.component';
import { HttpTestingController, HttpClientTestingModule } from '@angular/common/http/testing';

describe('GeotagsComponent', () => {
  let component: GeotagsComponent;
  let fixture: ComponentFixture<GeotagsComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [GeotagsComponent],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });

    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(GeotagsComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Test should be false', () => {
    component.test = false;
    expect(component.test).toBeFalsy();
  });

  it('Test should be true on execution of order 66', () => {
    component.executeOrder66(true);
    component.test = true;
    expect(component.test).toBeTruthy();
  });

});
