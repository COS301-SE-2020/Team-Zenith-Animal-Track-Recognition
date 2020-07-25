import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UtilityNavigationComponent } from './utility-navigation.component';

describe('UtilityNavigationComponent', () => {
  let component: UtilityNavigationComponent;
  let fixture: ComponentFixture<UtilityNavigationComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UtilityNavigationComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UtilityNavigationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
