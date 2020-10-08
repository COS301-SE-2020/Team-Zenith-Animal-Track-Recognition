import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalStatisticsComponent } from './animal-statistics.component';

describe('AnimalStatisticsComponent', () => {
  let component: AnimalStatisticsComponent;
  let fixture: ComponentFixture<AnimalStatisticsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnimalStatisticsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnimalStatisticsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
