import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UtilityNavigationComponent } from './utility-navigation.component';
import { HttpTestingController, HttpClientTestingModule } from '@angular/common/http/testing';
import { RouterTestingModule } from '@angular/router/testing';

describe('UtilityNavigationComponent', () => {
  let component: UtilityNavigationComponent;
  let fixture: ComponentFixture<UtilityNavigationComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [UtilityNavigationComponent],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });


    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(UtilityNavigationComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Username should be undefined', () => {
    expect(component.username).toBeUndefined();
  });

  it('Username should be null oninit', () => {
    component.ngOnInit();
    expect(component.username).toBeNull();
  });

  it('Username should be undefined', () => {
    component.logout();
    expect(component.username).toBeUndefined();
  });

});
