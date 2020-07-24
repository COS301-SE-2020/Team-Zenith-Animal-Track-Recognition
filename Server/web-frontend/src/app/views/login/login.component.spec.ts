import { RouterTestingModule } from '@angular/router/testing';
import { FormBuilder } from '@angular/forms';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LoginComponent } from './login.component';
import { HttpTestingController, HttpClientTestingModule } from '@angular/common/http/testing';

describe('LoginComponent', () => {
  let component: LoginComponent;
  let fixture: ComponentFixture<LoginComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [LoginComponent, FormBuilder],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });


    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(LoginComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Loading should be true', () => {
    expect(component.loading).toBeFalsy();
  });

  it('Submitted should be false', () => {
    expect(component.submitted).toBeFalsy();
  });

  it('Welcome should equal Hello after attempting to submit', () => {
    component.onSubmit(true);
    expect(component.submitted).toBeTruthy();
    expect(component.welcome).toEqual("Hello");
  });

  it('Welcome should equal Goodbye', () => {
    component.welcome = "Goodbye"
    expect(component.welcome).toEqual("Goodbye");
  });

  it('returnURL should equal /ranger', () => {
    component.returnUrl = "/ranger"
    expect(component.returnUrl).toEqual("/ranger");
  });

  it('Check on initialise', () => {
    component.ngOnInit();
    expect(component.welcome).toBeDefined();
    expect(component.returnUrl).toBeDefined();
  });
});
