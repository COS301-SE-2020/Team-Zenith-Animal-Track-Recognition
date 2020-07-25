import { AnimalsComponent } from './views/animals/animals.component';
import { TestBed, async, ComponentFixture } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { AppComponent} from './app.component';
import { RangersComponent } from './views/rangers/rangers.component';

describe('AppComponent', () => {  
  let component: AppComponent;
  let fixture: ComponentFixture<AppComponent>;
  
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [AppComponent],
    });

    component = TestBed.get(AppComponent);
  });

  it('Should generate a title', () => {
    expect(component.title).toEqual("web-frontend");
  })
});
