import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SettingsComponent } from './settings.component';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

describe('SettingsComponent', () => {
  let component: SettingsComponent;
  let fixture: ComponentFixture<SettingsComponent>;
  let httpTestingController: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [SettingsComponent],
      imports: [
        HttpClientTestingModule
      ]
    });


    httpTestingController = TestBed.get(HttpTestingController);
    component = TestBed.get(SettingsComponent);
  });


  it('should return true on method', () => {
    component.setTest(true);
    expect(component.test).toBeTruthy();
  });

  it('should return false on method', () => {
    component.setTest(false);
    expect(component.test).toBeFalsy();
  });

});
