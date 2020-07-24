import { AnimalsComponent } from './views/animals/animals.component';
import { TestBed, async } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { AppComponent} from './app.component';
import { RangersComponent } from './views/rangers/rangers.component';

describe('AppComponent', () => {
  it('Should generate a title', () => {
    let component = new AppComponent();

    expect(component.title).toEqual("web-frontend");
  })
});
