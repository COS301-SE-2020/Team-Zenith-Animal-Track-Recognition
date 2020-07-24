import { RouterTestingModule } from '@angular/router/testing';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SideNavigationComponent } from './side-navigation.component';
import { HttpTestingController, HttpClientTestingModule } from '@angular/common/http/testing';

describe('SideNavigationComponent', () => {
  let component: SideNavigationComponent;
  let fixture: ComponentFixture<SideNavigationComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [SideNavigationComponent],
      imports: [
        HttpClientTestingModule,
        RouterTestingModule
      ]
    });


    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(SideNavigationComponent);
  });

  afterEach(() => {
    httpTestingController.verify();
  });

  it('Test should be false', () => {    component.test = false;
    expect(component.test).toBeFalsy();
  });

});
