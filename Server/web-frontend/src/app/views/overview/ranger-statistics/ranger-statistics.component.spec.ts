import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RangerStatisticsComponent } from './ranger-statistics.component';

describe('RangerStatisticsComponent', () => {
  let component: RangerStatisticsComponent;
  let fixture: ComponentFixture<RangerStatisticsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RangerStatisticsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RangerStatisticsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
