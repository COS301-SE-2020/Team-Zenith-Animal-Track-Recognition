import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalInfoCardComponent } from './animal-info-card.component';

describe('AnimalInfoCardComponent', () => {
  let component: AnimalInfoCardComponent;
  let fixture: ComponentFixture<AnimalInfoCardComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnimalInfoCardComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnimalInfoCardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
